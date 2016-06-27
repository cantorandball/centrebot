require "rails_helper"

RSpec.describe IncomingMessageHandler do
  context "on initial message" do
    it "replies with the first question" do
      first_question = create(:question)

      handler = described_class.new("sms", "447702342164")
      message = handler.run("hi bot")

      expect(message).to eq(first_question.text)
    end
  end

  context "on subsequent messages" do
    it "replies with the next question" do
      create(:responder, source: "sms", identifier: "447702342164")
      first_question = create(:question, text: "Is your favourite colour blue?")
      second_question = create(:question, text: "Do you like cheese?")
      create(:outcome, value: "yes", question: first_question,
                       next_question: second_question)

      handler = described_class.new("sms", "447702342164")
      message = handler.run("yes")

      expect(message).to eq(second_question.text)
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

      handler = described_class.new("sms", "447702342164")
      message = handler.run("answer")

      expect(message).to eq("You've reached the end!")
    end
  end
end
