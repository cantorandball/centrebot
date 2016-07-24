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

  describe "outcome_for" do
    it "reset keyword is always an outcome with the first q as its next q" do
      first_question = create(:question)
      create(:question)
      outcome = first_question.outcome_for("restart")
      expect(outcome.next_question).to eq(first_question)
    end
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

    it "creates answers correctly" do
      question = create(:question, text: "Look for me")
      responder = create(:responder)
      answer = question.answer(responder, "Message from user")

      expect(answer.text).to eql("Message from user")
      expect(answer.question).to eql(question)
      expect(answer.question_text).to eql(question.text)
    end

    it "always validates the reset keyword" do
      expect(question.valid_answer?(Outcome::ResetKeyword)).to be_truthy
      mc_question = create(:multiple_choice_question)
      expect(mc_question.valid_answer?(Outcome::ResetKeyword)).to be_truthy
    end

    context "When archiving a question" do
      it "sets the 'archived' attribute on that question" do
        question.archive
        expect(question.archived)
      end

      it "does not delete associated outcomes" do
        outcome = create(:outcome,
                         question: question,
                         value: "Do not delete me")
        question.archive
        expect(outcome).to be_present
      end

      it "does not delete associated answers" do
        responder = create(:responder)
        answer = question.answer(responder, "Don't delete me")

        question.archive
        expect(question).to be_present
        expect(answer).to be_present
      end
    end
  end
end
