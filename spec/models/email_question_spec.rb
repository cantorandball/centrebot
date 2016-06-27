require "rails_helper"

RSpec.describe EmailQuestion do
  it "has a valid factory" do
    expect(create(:email_question)).to be_valid
  end

  it "throws an exception when parsing addresses without an @" do
    email_question = create(:email_question)

    expect do
      email_question.parse("whatevenisemail")
    end.to raise_error(InvalidInputError)
  end
end
