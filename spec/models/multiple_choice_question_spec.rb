require "rails_helper"

RSpec.describe MultipleChoiceQuestion do
  it "has a valid factory" do
    expect(create(:multiple_choice_question)).to be_valid
  end

  it "has multiple outcomes with values" do
    outcomes = create(:multiple_choice_question).outcomes
    expect(outcomes.length).to eql(3)
    outcomes.each do |outcome|
      expect(outcome.value).to eql('3: pidgeons')
    end
  end
end
