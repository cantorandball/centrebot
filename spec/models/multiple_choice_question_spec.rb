require "rails_helper"

RSpec.describe MultipleChoiceQuestion do
  it "has a valid factory" do
    expect(create(:multiple_choice_question)).to be_valid
  end

  it "has multiple outcomes with values" do
    outcomes = create(:multiple_choice_question).outcomes
    expect(outcomes.length).to eql(3)
    outcomes.each do |outcome|
      expect(outcome.value).to eql("3: Pidgeons")
    end
  end

  context "when validating answers" do
    before(:each) do
      @multichoice_question = create(:multiple_choice_question)
    end

    it "accepts answers which match an outcome value" do
      expect(@multichoice_question.valid_answer?("3: Pidgeons")).to be
    end

    it "rejects answers which are not options" do
      invalid_inputs = %w(5 Eagles 30 pi)
      invalid_inputs.each do |invalid_input|
        expect(@multichoice_question.valid_answer?(invalid_input)).to be_falsey
      end
    end
  end

  context "when parsing answers" do
    before(:each) do
      @multichoice_question = create(:multiple_choice_question)
    end

    it "throws an exception if the answer is not an option" do
      invalid_inputs = %w(5 Eagles 30 pi)
      invalid_inputs.each do |invalid_input|
        expect do
          @multichoice_question.parse(invalid_input)
        end.to raise_error(InvalidInputError)
      end
    end

    it "expands answers which are just numbers" do
      valid_inputs = %w(3 3.)
      valid_inputs.each do |valid_input|
        observed = @multichoice_question.parse(valid_input)
        expected = "3: Pidgeons"
        expect(observed).to eql(expected)
      end
    end

    it "expands answers which are just text" do
      valid_inputs = %w(pidgeons Pidgeons 3:\ Pidgeons)
      valid_inputs.each do |valid_input|
        observed = @multichoice_question.parse(valid_input)
        expected = "3: Pidgeons"
        message = "Expected #{expected}, got #{observed}"
        expect(observed).to eql(expected), message
      end
    end
  end
end
