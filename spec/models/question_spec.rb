require "rails_helper"

RSpec.describe Question do
  it "has a valid factory" do
    expect(create(:question)).to be_valid
  end

  it "is invalid without text" do
    expect(build(:question, text: nil)).not_to be_valid
  end

  it "it invalid with text longer than 140 characters" do
    long_message = "This is a long message which should not be valid. " \
      "Especially because it is overly wordy and doesn’t really tell you " \
      "anything. Like, at all, really."

    expect(build(:question, text: long_message)).not_to be_valid
  end

  it "returns input lowercase" do
    question = create(:question)
    input = "HuBBlE"
    parsed_input = question.parse(input)
    expect(parsed_input).to eql(input.downcase)
  end

  describe "valid_answer?" do
    let(:question) do
      question = create(:question)

      create(:outcome, question: question, value: "yes")

      question
    end

    it "is true when a valid outcome matches the answer text" do
      expect(question.valid_answer?("yes")).to be_truthy
    end

    it "is false when no valid outcome matches the answer text" do
      expect(question.valid_answer?("no")).to be_falsey
    end
  end
end
