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
      create(:responder, source: "sms", identifier: "447702342164")
      first_question = create(:question, text: "Is your favourite colour blue?")
      second_question = create(:question, text: "Do you like cheese?")
      create(:outcome, value: "yes", question: first_question,
                       next_question: second_question)
      allow(NexmoClient).to receive(:send_message)

      post "/api/v1/incoming/nexmo", subsequent_webhook_params

      expect(response).to be_a_success
      expect(json).to be_a(Hash)
      expect(json["message"]).to eq(second_question.text)

      expect(NexmoClient).to have_received(:send_message).
        with(to: "447702342164", text: second_question.text)
    end
  end

  context "on the final message" do
    it "replies with the final text" do
      responder = create(:responder, source: "sms", identifier: "447702342164")
      first_question = create(:question, text: "Is your favourite colour blue?")
      second_question = create(:question, text: "Do you like cheese?")
      create(:outcome, value: "yes", question: first_question,
                       next_question: second_question)
      create(:answer, text: "yes", responder: responder,
                      question: first_question)
      allow(NexmoClient).to receive(:send_message)

      post "/api/v1/incoming/nexmo", subsequent_webhook_params

      expect(response).to be_a_success
      expect(json).to be_a(Hash)
      expect(json["message"]).to eq("You've reached the end!")

      expect(NexmoClient).to have_received(:send_message).
        with(to: "447702342164", text: "You've reached the end!")
    end
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
      "text" => "yes",
      "type" => "text",
      "keyword" => "HI",
      "message-timestamp" => "2016-06-23 10:14:04",
    }
  end
end
