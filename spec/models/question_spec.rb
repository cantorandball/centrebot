require "rails_helper"

RSpec.describe Question do
  it "has a valid factory" do
    expect(create(:question)).to be_valid
  end

  it "is invalid without text" do
    expect(build(:question, text: nil)).not_to be_valid
  end

  it "is invalid with text longer than 140 characters" do
    long_message = "This is a long message which should not be valid. " \
      "Especially because it is overly wordy and doesn’t really tell you " \
      "anything. Like, at all, really."

    expect(build(:question, text: long_message)).not_to be_valid
  end

  it "returns a human readable string when asked" do
    question = create(:question, text: "Brine owl")
    expected_description = "#{question.id}: #{question.text}"
    expect(question.describe).to eql(expected_description)
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

  context "When deleting a question" do

    it "deletes associated outcomes" do
      question = create(:question)
      create(:outcome, question: question, value: "delete me")
      question.destroy
      expect(question.outcomes.length).to eql(0)
    end

    it "does not delete associated answers" do
      question = create(:question)
      answer = create(:answer, question: question, text: "Do not delete me")
      question.destroy
      expect(answer).to exist
    end
  end
  end
end
