require "rails_helper"

RSpec.describe Responder do
  it "has a valid factory" do
    expect(create(:responder)).to be_valid
  end

  it "is invalid without a source" do
    expect(build(:responder, source: nil)).not_to be_valid
  end

  it "is invalid with an unknown source" do
    expect(build(:responder, source: "pidgeon_post")).not_to be_valid
  end

  it "is invalid without an identifier" do
    expect(build(:responder, identifier: nil)).not_to be_valid
  end

  it "deletes answers when deleting responders" do
    responder = create(:responder)
    create(:answer, responder: responder)

    responder.destroy

    expect(Answer.all).to eq([])
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

    it "returns nil when there's no further questions" do
      responder = create(:responder)

      first_question = create(:question, text: "Is your favourite colour blue?")
      create(:outcome, value: "yes", question: first_question)

      create(:answer, text: "yes", responder: responder,
                      question: first_question)

      expect(responder.current_question).to eq(nil)
    end
  end
end
