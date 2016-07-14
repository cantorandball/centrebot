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

  it "defines a set of states" do
    expect(Responder::Initial).to eq("initial")
    expect(Responder::Active).to eq("active")
    expect(Responder::Completed).to eq("completed")

    expect(Responder::States).to eq([Responder::Initial,
                                     Responder::Active,
                                     Responder::Completed])
  end

  it "has an initial state" do
    responder = create(:responder)

    expect(responder.state).to eq(Responder::Initial)
  end

  it "is invalid with an unknown state" do
    expect(build(:responder, state: "unknown")).not_to be_valid
  end

  it "deletes answers when deleting responders" do
    responder = create(:responder)
    question = create(:question)

    question.answer(responder, "Answer text")
    responder.destroy

    expect(Answer.all).to eq([])
  end

  context "when the responder has began answering questions" do
    before(:each) do
      @responder = create(:responder)
      @first_question = create(:question,
                               text: "Is your favourite colour blue?")
      @second_question = create(:question,
                                text: "Do you like cheese?")

      create(:outcome,
             value: "yes",
             question: @first_question,
             next_question: @second_question)

      @first_question.answer(@responder, "yes")
    end

    it "has a previous question" do
      expect(@responder.previous_question).to eq(@first_question)
    end

    it "has a current question" do
      expect(@responder.current_question).to eq(@second_question)
    end

    it "returns nil when there's no further questions" do
      @second_question.answer(@responder, "yes")
      expect(@responder.current_question).to eq(nil)
    end
  end
end
