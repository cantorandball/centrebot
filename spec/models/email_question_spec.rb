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

  it "throws an excpetion when there's no domain name" do
    email_question = create(:email_question)
    expect do
      email_question.parse("whatevenisemail@lol")
    end.to raise_error(InvalidInputError)
    expect do
      email_question.parse("whatevenisemail@lol.")
    end.to raise_error(InvalidInputError)
  end

  it "throws an excpetion when there's no address" do
    email_question = create(:email_question)
    expect do
      email_question.parse("@no.way")
    end.to raise_error(InvalidInputError)
  end

  it "returns a parsed string" do
    email_question = create(:email_question)
    parsed_value = email_question.parse("VALID.Email@yes.OK")
    expect(parsed_value).to eql("valid.email@yes.ok")
  end
end
