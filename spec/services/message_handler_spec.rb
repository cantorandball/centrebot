require "rails_helper"

RSpec.describe MessageHandler do
  before(:each) do
    setup_question_tree
  end

  context "on every message" do
    before(:each) do
      @responder = create(:responder, state: Responder::Active)
      @responder.answers << create(:answer,
                                  question: @questions[0],
                                  text: "yes")
      @responder.answers << create(:answer,
                                  question: @questions[1],
                                  text: "it's in tents")
    end

    it "replies with the outcome message if there is one" do
      fourth_question = create(:question)
      @questions[2].outcomes.create(value: "Brine",
                                      next_question: fourth_question,
                                      message: "This should show up")
      handler = described_class.new(@responder, "Brine")
      expect(handler.next_response).to eq(["This should show up",
                                           fourth_question.text])
    end

    it "returns to the first question if the last answer was a reset" do
      expect(@responder.current_question).to eq(@questions[2])
      @responder.answers << create(:answer,
                                   question: @questions[2],
                                   text: Outcome::ResetKeyword)
      expect(@responder.current_question).to eq(@questions[0])
    end

    it "returns to the first question if the reset keywork is sent" do
      expect(@responder.current_question).to eq(@questions[2])
      handler = described_class.new(@responder, "restart")

      expect(handler.next_response).to eq([@questions[0].text])
      expect(@responder.current_question).to eq(@questions[0])
      expect(@responder.answers.last.text).to eq("restart")
    end
  end

  context "on initial message" do
    it "replies with the first question" do
      responder = create(:responder)

      handler = described_class.new(responder, "hi bot")

      expect(handler).to be_valid
      expect(handler.next_response.first).to eq("This is the first question. " \
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
      responder.answers << create(:answer,
                                  question: @questions[0],
                                  text: "yes")
      responder.answers << create(:answer,
                                  question: @questions[1],
                                  text: "it's in tents")

      handler = described_class.new(responder, "Pinkle")

      expect(handler).not_to be_valid
      expect(handler.next_response).to be_nil
      expect(handler.error_response.first).to be_a(String)
    end
  end

  context "on subsequent messages" do
    it "replies with the next question" do
      responder = create(:responder, state: Responder::Active)
      responder.answers << create(:answer,
                                  question: @questions[0],
                                  text: "yes")

      handler = described_class.new(responder, "it's in tents")

      expect(handler).to be_valid
      expect(handler.next_response.first).to eq("Are you bored with this yet?")
    end
  end

  context "on the final message" do
    before(:each) do
      @responder = create(:responder, state: Responder::Active)
      @responder.answers << create(:answer,
                                   question: @questions[0],
                                   text: "yes")
      @responder.answers << create(:answer,
                                   question: @questions[1],
                                   text: "it's in tents")

      @handler = described_class.new(@responder, "no!")
    end

    it "replies with the final text" do
      outcome = @questions[2].outcomes.create(value: "no!",
                                                next_question: nil,
                                                message: "Go in peace")
      expect(@handler).to be_valid
      expect(@handler.next_response.first).to eq(outcome.message)
      expect(@responder.state).to eq(Responder::Completed)
    end

    it "replies with a default message if there is no final text" do
      @questions[2].outcomes.create(value: "no!", next_question: nil)
      expect(@handler.next_response.first).to eq(@handler.terminating_statement)
      expect(@responder.state).to eq(Responder::Completed)
    end
  end

  context "with a completed responder" do
    it "returns the first question" do
      responder = create(:responder, state: Responder::Completed)
      responder.answers << create(:answer,
                                  question: @questions[0],
                                  text: "yes")
      handler = described_class.new(responder, "Hello again")
      expect(handler).to be_valid
      expect(handler.next_response.first).to eq(@questions[0].text)
      expect(responder.state).to eq(Responder::Active)
    end
  end

  context "when responding to a date question" do
    before(:each) do
      @date_question = create(:date_question)
      @questions[2].outcomes.create(value: "Date please",
                                      next_question: @date_question)

      @responder = create(:responder, state: Responder::Active)
      @responder.answers << create(:answer,
                                   question: @questions[2],
                                   text: "Date please")

      @date_question.outcomes.create(type: "DateOutcome",
                                    upper_bound: 6,
                                    next_question: @questions[0])

      @date_question.outcomes.create(type: "DateOutcome",
                                    lower_bound: 6,
                                    upper_bound: 3,
                                    next_question: @questions[1])

      @date_question.outcomes.create(type: "DateOutcome",
                                    lower_bound: 3,
                                    next_question: @questions[2])
    end

    it "returns the correct next question on a low answer" do
      seven_years = Date.today.prev_year(7).strftime("%d/%m/%Y")
      handler = described_class.new(@responder, seven_years)
      expect(handler.next_response).to eq([@questions[0].text])
    end

    it "returns the correct next question on a medium answer" do
      four_years = Date.today.prev_year(4).strftime("%d/%m/%Y")
      handler = described_class.new(@responder, four_years)
      expect(handler.next_response).to eq([@questions[1].text])
    end

    it "parses errors correctly" do
      handler = described_class.new(@responder, "Some bull")
      expect(handler.next_response).to be_nil
    end

    it "allows users to restart" do
      expect(@responder.current_question).to eq(@date_question)
      handler = described_class.new(@responder, "RestarT")
      expect(handler.next_response).to eq([@questions[0].text])
    end
  end

  describe "valid?" do
    it "validates anything if there is no current question" do
      responder = create(:responder, state: Responder::Active)
      responder.answers << create(:answer,
                                  question: @questions[2],
                                  text: "End this")
      expect(responder.current_question).not_to be
      handler = described_class.new(responder, "Oh hey there")
      expect(handler.valid?).to be
    end
  end

  describe "next_response" do
    it "returns the first response if there's no current question" do
      responder = create(:responder, state: Responder::Active)
      responder.answers << create(:answer,
                                  question: @questions[2],
                                  text: "End this")
      expect(responder.current_question).not_to be
      handler = described_class.new(responder, "Oh hey there")
      expect(handler.next_response[0]).to eq(@questions[0].text)
      handler = described_class.new(responder, "Yes")
      expect(handler.next_response[0]).to eq(@questions[1].text)
    end
  end

  describe "current_question" do
    it "returns_the first question if the responder has no current question" do
      responder = create(:responder, state: Responder::Active)
      responder.answers << create(:answer,
                                  question: @questions[2],
                                  text: "End this")
      expect(responder.current_question).not_to be
      handler = described_class.new(responder, "Oh hey there")
      expect(responder.current_question).not_to be
      cq = handler.send(:current_question)
      expect(handler.send(:current_question)).to eq(@questions[0])
    end
  end

  def setup_question_tree
    @questions = [
      create(:multiple_choice_question,
             text: "This is the first question. " \
             "Do you like cheese?"),
      create(:open_text_question,
             text: "Explain why or why you don't like camping."),
      create(:multiple_choice_question,
             text: "Are you bored with this yet?")
    ]
    @questions[0].outcomes.create(value: "yes",
                                  next_question: @questions[1])
    @questions[1].outcomes.create(value: "it's in tents",
                                  next_question: @questions[2])
    @questions[2].outcomes.create(value: "End this",
                                  next_question: nil)
  end
end
