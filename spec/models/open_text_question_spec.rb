require "rails_helper"

RSpec.describe OpenTextQuestion do
  it "has a valid factory" do
    expect(create(:open_text_question)).to be_valid
  end

  context "when parsing a message" do
    it "returns strings unchanged" do
      open_text_question = create(:open_text_question)
      in_message = "OH WOW ok :)"
      expect(open_text_question.parse(in_message)).to eql(in_message)
    end
  end

  context "when validating an answer" do
    it "will accept answers for which there is no defined outcome value" do
      open_text_question = create(:open_text_question)
      expect(open_text_question.valid_answer?("arbitrary")).to be_truthy
    end

    it "will accept long messages" do
      open_text_question = create(:open_text_question)
      long_message = "blah " * 100
      expect(open_text_question.valid_answer?(long_message)).to be_truthy
    end
  end
end
