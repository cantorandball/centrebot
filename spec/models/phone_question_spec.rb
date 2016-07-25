require "rails_helper"

RSpec.describe PhoneQuestion do
  it "has a valid factory" do
    expect(create(:phone_question)).to be_valid
  end

  it "has an outcome type" do
    expect(create(:phone_question).outcome_type).to eq("Outcome")
  end

  it "parses valid numbers" do
    valid_numbers = ["01223 778 778", "+44(0) 2076 992 883"]
    valid_numbers.each do |valid_number|
      phone_question = create(:phone_question)
      observed = phone_question.parse(valid_number)
      expect(observed).to eql(valid_number)
    end
  end

  it "rejects invalid numbers" do
    invalid_numbers = ["bugger off", "+44(0) 2076 992 88"]
    invalid_numbers.each do |valid_number|
      expect do
        phone_question = create(:phone_question)
        phone_question.parse(valid_number)
      end.to raise_error(InvalidInputError)
    end
  end
end
