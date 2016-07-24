require "rails_helper"

RSpec.describe "Incoming Nexmo Webhook" do
  let(:json) { JSON.parse(response.body) }

  context "when contacted without an identifier" do
    it "sends back the first response" do
      first_response = "First response to a responder without an identifier"

      allow(NexmoClient).to receive(:send_message).
        with(to: nil, text: first_response)

      post "/api/v1/incoming/nexmo", bare_params

      expect(response).to be_a_success
      expect(json).to be_a(Hash)
      expect(json["message"]).to eq(first_response)
    end
  end

  context "on initial message" do
    it "replies with the first question" do
      first_question = create(:question)
      allow(NexmoClient).to receive(:send_message).
        with(to: "447702342164", text: first_question.text)

      post "/api/v1/incoming/nexmo", initial_webhook_params

      expect(response).to be_a_success
      expect(json).to be_a(Hash)
      expect(json["message"]).to eq(first_question.text)

      expect(NexmoClient).to have_received(:send_message)
    end
  end

  context "on an invalid answer" do
    before(:each) do
      setup_question_tree
      allow(NexmoClient).to receive(:send_message)
    end
  end

  context "on subsequent messages" do
    before(:each) do
      setup_question_tree
      allow(NexmoClient).to receive(:send_message)
    end

    it "doesn't reply with the first message over and over" do
      post "/api/v1/incoming/nexmo", initial_webhook_params
      post "/api/v1/incoming/nexmo", second_webhook_params

      expect(response).to be_a_success
      expect(json).to be_a(Hash)
      expect(json["message"]).to eq(Question.second.text)
    end

    it "replies with the next question" do
      responder = create(:responder, source: "sms",
                                     identifier: "447702342164",
                                     state: Responder::Active)
      responder.answers << create(:answer, question: Question.first,
                                           text: "yes")

      post "/api/v1/incoming/nexmo", subsequent_webhook_params

      expect(response).to be_a_success
      expect(json).to be_a(Hash)
      expect(json["message"]).to eq(Question.third.text)

      expect(NexmoClient).to have_received(:send_message).
        with(to: "447702342164", text: Question.third.text)
    end

    it "returns the first question if the reset keyword is sent" do
      responder = create(:responder, source: "sms",
                                     identifier: "447702342164",
                                     state: Responder::Active)
      responder.answers << create(:answer, question: Question.first,
                                           text: "yes")
      post "/api/v1/incoming/nexmo", reset_webhook_params

      expect(response).to be_a_success
      expect(json).to be_a(Hash)
      expect(json["message"]).to eq(Question.first.text)
    end
  end

  context "on the final message" do
    before(:each) do
      setup_question_tree
      allow(NexmoClient).to receive(:send_message)
    end

    it "replies with the final text" do
      responder = create(:responder, source: "sms",
                                     identifier: "447702342164",
                                     state: Responder::Active)
      responder.answers << create(:answer, question: Question.first,
                                           text: "yes")
      responder.answers << create(:answer, question: Question.second,
                                           text: "it's in tents")

      allow(NexmoClient).to receive(:send_message)

      post "/api/v1/incoming/nexmo", final_webhook_params

      expect(response).to be_a_success
      expect(json).to be_a(Hash)
      expect(json["message"]).to eq("You've reached the end!")

      expect(NexmoClient).to have_received(:send_message).
        with(to: "447702342164", text: "You've reached the end!")
    end
  end

  def setup_question_tree
    first_question = create(:multiple_choice_question,
                            text: "This is the first question. "\
                                  "Do you like cheese?",
                            type: "MultipleChoiceQuestion")

    second_question = create(:question,
                             text: "Explain why or why you don't like camping.",
                             type: "OpenTextQuestion")

    third_question = create(:question,
                            text: "When were you born?",
                            type: "DateQuestion")

    first_question.outcomes.create(value: "yes", next_question: second_question)
    second_question.outcomes.create(value: "it's in tents",
                                    next_question: third_question)
    third_question.outcomes.create(value: "no!")
  end

  def webhook_params(text)
    {
        "msisdn" => "447702342164",
        "to" => "447507332120",
        "messageId" => "02000000E353E124",
        "text" => text,
        "type" => "text",
        "keyword" => text.upcase,
        "message-timestamp" => "2016-06-23 10:14:04",
    }
  end

  def initial_webhook_params
    webhook_params("hi bot")
  end

  def second_webhook_params
    webhook_params("yes")
  end

  def subsequent_webhook_params
    webhook_params("it's in tents")
  end

  def final_webhook_params
    webhook_params("06/05/1989")
  end

  def bare_params
    { "text" => "A message sent from Nexmo" }
  end

  def reset_webhook_params
    webhook_params(Outcome::ResetKeyword)
  end
end
