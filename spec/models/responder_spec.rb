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

  describe "initial_answer" do
    before(:each) do
      @responder = create(:responder)
      @message = "This is my first message"
      @question_text = "First contact:"
    end

    it "creates an initial question and answers it if it's not there" do
      @responder.initial_answer(@message)
      expect(Question.all.size).to eq(1)
      first_question = Question.all.first
      expect(first_question.text).to eq(@question_text)
      expect(first_question).to be_an(OpenTextQuestion)
      expect(@responder.answers.size).to eq(1)
      expect(@responder.answers.first.text).to eq(@message)
      expect(@responder.answers.first.question_text).to eq(@question_text)
    end

    it "answers the initial question it if it's not there" do
      create(:question, text: @question_text)
      @responder.initial_answer(@message)
      expect(Question.all.size).to eq(1)
      expect(Question.all.first.text).to eq(@question_text)
      expect(@responder.answers.size).to eq(1)
      expect(@responder.answers.first.text).to eq(@message)
    end

    it "creates an outcome leading from the initial_question to the first" do
      first_question = create(:question)
      @responder.initial_answer(@message)
      outcomes = Question.second.outcomes
      expect(outcomes.size).to eq(1)
      expect(outcomes.first.next_question).to eq(first_question)
    end
  end

  describe "current_question" do
    before(:each) do
      @responder = create(:responder)
    end

    it "returns the prev question if a nonvalid answer has been given" do
      first_question = create(:multiple_choice_question, text: "Y?")
      second_question = create(:multiple_choice_question, text: "OK!")
      create(:outcome,
             value: "Y",
             question: first_question,
             next_question: second_question)
      first_question.answer(@responder, "Whoa nope lol")
      expect(@responder.current_question).to eq(first_question)
    end

#    it "returns the first question if outcome_for(previous_question) is nil" do
#      first_question = create(:multiple_choice_question)
#      second_question = create(:date_question, text: "What's your fave date?")
#      create(:outcome,
#             value: nil,
#             question: second_question,
#             next_question: nil)
#
#      second_question.answer(@responder, "05/06/1978")
#      expect(@responder.current_question).to eq(first_question)
#    end
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

    it "returns the correct previous question when ids are mixed" do
      fourth_question = create(:question,
                              text: "Is this the fourth question?")
      third_question = create(:question,
                              text: "Is this the third question")
      fifth_question = create(:question,
                              text: "Is this the fifth question?")

      expect(third_question.id).to be > fourth_question.id

      create(:outcome,
             question: @second_question,
             next_question: third_question,
             value: "To third")
      create(:outcome,
             question: third_question,
             next_question: fourth_question,
             value: "To fourth")
      create(:outcome,
            question: fourth_question,
            next_question: fifth_question,
            value: "To fifth")

      @second_question.answer(@responder, "To third")
      third_question.answer(@responder, "To fourth")
      fourth_question.answer(@responder, "To fifth")
      expect(@responder.previous_question).to eq(fourth_question)
    end
  end
end
