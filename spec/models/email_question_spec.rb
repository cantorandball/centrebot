require "rails_helper"

RSpec.describe EmailQuestion do
  before(:each) do
    @email_question = create(:email_question)
  end

  it "has a valid factory" do
    expect(create(:email_question)).to be_valid
  end

  it "has an outcome type" do
    expect(@email_question.outcome_type).to eq(:outcomes)
  end

  it "throws an exception when parsing addresses without an @" do
    expect do
      @email_question.parse("whatevenisemail")
    end.to raise_error(InvalidInputError)
  end

  it "throws an excpetion when there's no domain name" do
    expect do
      @email_question.parse("whatevenisemail@lol")
    end.to raise_error(InvalidInputError)
    expect do
      @email_question.parse("whatevenisemail@lol.")
    end.to raise_error(InvalidInputError)
  end

  it "throws an exception when there's no address" do
    expect do
      @email_question.parse("@no.way")
    end.to raise_error(InvalidInputError)
  end

  it "returns a parsed string" do
    parsed_value = @email_question.parse("VALID.Email@yes.OK")
    expect(parsed_value).to eql("valid.email@yes.ok")
  end

  context "when validating an email address" do
    it "validates a valid email address" do
      expect(@email_question.valid_answer?("j@h.vo")).to be
    end
  end
end
