require "rails_helper"

RSpec.describe "Incoming Nexmo Webhook" do

  let(:json) { JSON.parse(response.body) }

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

  context "on subsequent messages" do
    it "replies with the next question" do
      setup_question_tree
      responder = create(:responder, source: "sms",
                                     identifier: "447702342164",
                                     state: Responder::Active)
      responder.answers << create(:answer, question: Question.first,
                                           text: "yes")

      allow(NexmoClient).to receive(:send_message)

      post "/api/v1/incoming/nexmo", subsequent_webhook_params

      expect(response).to be_a_success
      expect(json).to be_a(Hash)
      expect(json["message"]).to eq(Question.third.text)

      expect(NexmoClient).to have_received(:send_message).
        with(to: "447702342164", text: Question.third.text)
    end
  end

  context "on the final message" do
    it "replies with the final text" do
      setup_question_tree
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
    first_question = create(:question,
                            text: "This is the first question. Do you like cheese?",
                            type: "MultipleChoiceQuestion")

    second_question = create(:question,
                             text: "Explain why or why you don't like camping.",
                             type: "OpenTextQuestion")

    third_question = create(:question,
                            text: "Are you bored with this yet?",
                            type: "MultipleChoiceQuestion")

    first_question.outcomes.create(value: "yes", next_question: second_question)
    second_question.outcomes.create(value: "it's in tents",
                                    next_question: third_question)
    third_question.outcomes.create(value: "no!")
  end

  def initial_webhook_params
    {
      "msisdn" => "447702342164",
      "to" => "447507332120",
      "messageId" => "02000000E353E124",
      "text" => "hi bot",
      "type" => "text",
      "keyword" => "HI",
      "message-timestamp" => "2016-06-23 10:14:04",
    }
  end

  def subsequent_webhook_params
    {
      "msisdn" => "447702342164",
      "to" => "447507332120",
      "messageId" => "02000000E353E124",
      "text" => "it's in tents",
      "type" => "text",
      "keyword" => "HI",
      "message-timestamp" => "2016-06-23 10:14:04",
    }
  end

  def final_webhook_params
    {
      "msisdn" => "447702342164",
      "to" => "447507332120",
      "messageId" => "02000000E353E124",
      "text" => "no!",
      "type" => "text",
      "keyword" => "HI",
      "message-timestamp" => "2016-06-23 10:14:04",
    }
  end
end
