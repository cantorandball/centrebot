require "rails_helper"

RSpec.describe MultipleChoiceQuestion do
  it "has a valid factory" do
    expect(create(:multiple_choice_question)).to be_valid
  end
end
