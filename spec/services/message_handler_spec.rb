require "rails_helper"

RSpec.describe MessageHandler do
  before(:each) do
    setup_question_tree
  end

  context "on initial message" do
    it "replies with the first question" do
      responder = create(:responder)

      handler = described_class.new(responder, "hi bot")

      expect(handler).to be_valid
      expect(handler.next_response).to eq("This is the first question. " \
        "Do you like cheese?")
    end
  end

  context "after the first answer" do
    it "has set the state on the responder to 'Active'" do
      responder = create(:responder)

      handler = described_class.new(responder, "Hello")
      handler.next_response

      expect(responder.state).to eq(Responder::Active)
    end
  end

  context "with an invalid answer" do
    it "replies with an error" do
      responder = create(:responder, state: Responder::Active)
      responder.answers << create(:answer, question: Question.first,
                                           text: "yes")

      handler = described_class.new(responder, "no")

      expect(handler).not_to be_valid
      expect(handler.next_response).to be_nil
      expect(handler.error_response).to be_a(String)
    end
  end

  context "on subsequent messages" do
    it "replies with the next question" do
      responder = create(:responder, state: Responder::Active)
      responder.answers << create(:answer, question: Question.first,
                                           text: "yes")

      handler = described_class.new(responder, "it's in tents")

      expect(handler).to be_valid
      expect(handler.next_response).to eq("Are you bored with this yet?")
    end
  end

  context "on the final message" do
    before(:each) do
      @responder = create(:responder, state: Responder::Active)
      @responder.answers << create(:answer, question: Question.first,
                                  text: "yes")
      @responder.answers << create(:answer, question: Question.second,
                                  text: "it's in tents")

      @handler = described_class.new(@responder, "no!")
    end

    it "replies with the final text" do
      outcome = @third_question.outcomes.create(value: "no!",
                                                next_question: nil,
                                                message: "Go in peace")
      expect(@handler).to be_valid
      expect(@handler.next_response).to eq(outcome.message)
      expect(@responder.state).to eq(Responder::Completed)
    end

    it "replies with a default message if there is no final text" do
      @third_question.outcomes.create(value: "no!", next_question: nil)
      expect(@handler.next_response).to eq(@handler.terminating_statement)
      expect(@responder.state).to eq(Responder::Completed)
    end
  end

  def setup_question_tree
    first_question = create(:question,
                            text: "This is the first question. " \
                            "Do you like cheese?",
                            type: "MultipleChoiceQuestion")

    second_question = create(:question,
                             text: "Explain why or why you don't like camping.",
                             type: "OpenTextQuestion")

    @third_question = create(:question,
                             text: "Are you bored with this yet?",
                             type: "MultipleChoiceQuestion")

    first_question.outcomes.create(value: "yes", next_question: second_question)
    second_question.outcomes.create(value: "it's in tents",
                                    next_question: @third_question)
  end
end
