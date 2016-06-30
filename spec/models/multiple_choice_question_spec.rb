require "rails_helper"

RSpec.describe MultipleChoiceQuestion do
  it "has a valid factory" do
    expect(create(:multiple_choice_question)).to be_valid
  end

  it "has multiple outcomes with values" do
    outcomes = create(:multiple_choice_question).outcomes
    expect(outcomes.length).to eql(3)
    outcomes.each do |outcome|
      expect(outcome.value).to eql('3: Pidgeons')
    end
  end

  it "accepts answers which are just numbers" do
    multiple_choice_question = create(:multiple_choice_question)
    valid_inputs = ['3', '3.']
    valid_inputs.each do |valid_input|
      observed = multiple_choice_question.parse(valid_input)
      expected = '3: Pidgeons'
      expect(observed).to eql?(expected)
    end
  end

  it "accepts answers which are just text" do
    multiple_choice_question = create(:multiple_choice_question)
    valid_inputs = ['pidgeons', 'Pidgeons', '3: Pidgeons']
    valid_inputs.each do |valid_input|
      observed = multiple_choice_question.parse(valid_input)
      expected = '3: Pidgeons'
      expect(observed).to eql?(expected)
    end
  end

  it "rejects answers which are not options" do
    multiple_choice_question = create(:multiple_choice_question)
    invalid_inputs = ['5', '3: Eagles', '30']
    invalid_inputs.each do |invalid_input|
      expect do
        multiple_choice_question.parse(invalid_input)
      end.to raise_error(InvalidInputError)
    end
  end
end
