require "rails_helper"

RSpec.describe Responder do
  it "has a valid factory" do
    expect(create(:responder)).to be_valid
  end

  context "when the responder has began answering questions" do
    it "has a previous question" do
      responder = create(:responder)

      first_question = create(:question, text: "Is your favourite colour blue?")
      second_question = create(:question, text: "Do you like cheese?")
      create(:outcome, value: "yes", question: first_question,
                       next_question: second_question)

      create(:answer, text: "yes", responder: responder,
                      question: first_question)

      expect(responder.previous_question).to eq(first_question)
    end

    it "has a previous answer" do
      responder = create(:responder)

      first_question = create(:question, text: "Is your favourite colour blue?")
      second_question = create(:question, text: "Do you like cheese?")
      create(:outcome, value: "yes", question: first_question,
                       next_question: second_question)

      create(:answer, text: "yes", responder: responder,
                      question: first_question)
    end

    it "has a current question" do
      responder = create(:responder)

      first_question = create(:question, text: "Is your favourite colour blue?")
      second_question = create(:question, text: "Do you like cheese?")
      create(:outcome, value: "yes", question: first_question,
                       next_question: second_question)

      create(:answer, text: "yes", responder: responder,
                      question: first_question)

      expect(responder.current_question).to eq(second_question)
    end
  end
end
