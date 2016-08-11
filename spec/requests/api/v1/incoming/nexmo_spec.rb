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
      expect(json["messages"].first).to eq(first_response)
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
      expect(json["messages"].first).to eq(first_question.text)

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

    it "saves the answer to the first contact" do
      post "/api/v1/incoming/nexmo", initial_webhook_params
      expect(Responder.all.size).to eq(1)
      expect(Responder.first.answers.size).to eq(1)
      expect(Answers.first.question).to be_nil
    end

    it "doesn't reply with the first message over and over" do
      post "/api/v1/incoming/nexmo", initial_webhook_params
      post "/api/v1/incoming/nexmo", second_webhook_params

      expect(response).to be_a_success
      expect(json).to be_a(Hash)
      expect(json["messages"].first).to eq(Question.second.text)
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
      expect(json["messages"].size).to eq(2)
      message = Question.second.outcomes.first.message
      expect(json["messages"].first).to eq(message)
      expect(json["messages"].second).to eq(Question.third.text)

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
      expect(json["messages"].first).to eq(Question.first.text)
    end
  end

  context "on the final message" do
    before(:each) do
      setup_question_tree
      allow(NexmoClient).to receive(:send_message)

      responder = create(:responder, source: "sms",
                         identifier: "447702342164",
                         state: Responder::Active)
      responder.answers << create(:answer, question: Question.first,
                                  text: "yes")
      responder.answers << create(:answer, question: Question.second,
                                  text: "it's in tents")
    end

    it "replies with the final text" do
      post "/api/v1/incoming/nexmo", final_webhook_params

      expect(response).to be_a_success
      expect(json).to be_a(Hash)
      expect(json["messages"].first).to eq("You've reached the end!")

      expect(NexmoClient).to have_received(:send_message).
        with(to: "447702342164", text: "You've reached the end!")
    end

    it "sends the first message on further contact" do
      post "/api/v1/incoming/nexmo", final_webhook_params
      expect(response).to be_a_success

      post "/api/v1/incoming/nexmo", initial_webhook_params
      expect(response).to be_a_success
      expect(json).to be_a(Hash)
      expect(json["messages"].first).to eq(@questions[0].text)
    end
  end

  def setup_question_tree
    @questions = [
      create(:multiple_choice_question,
             text: "This is the first question. "\
                  "Do you like cheese?",
             type: "MultipleChoiceQuestion"),
      create(:question,
             text: "Explain why or why you don't like camping.",
             type: "OpenTextQuestion"),
      create(:date_question,
            text: "When were you born?",
            type: "DateQuestion"),
    ]

    @questions[0].outcomes.create(value: "yes", next_question: @questions[1])
    @questions[1].outcomes.create(value: "it's in tents",
                                  next_question: @questions[2],
                                  message: "Yes. Yes it is.")
    @questions[2].outcomes.create(type: "DateOutcome", value: "no!")
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
