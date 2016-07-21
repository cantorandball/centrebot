require "rails_helper"

RSpec.describe DateQuestion do

  before(:each) do

    @date_question = create(:date_question)
    @dates_and_conversions = []
    @dates_and_conversions.push("in" => "9/8/1989", "out" => "09.08.1989")
    @dates_and_conversions.push("in" => "5.3.2001", "out" => "05.03.2001")
    @dates_and_conversions.push("in" => "3rd Feb 1999", "out" => "03.02.1999")
    @dates_and_conversions.push("in" => "21st July 1999", "out" => "21.07.1999")
    @invalid_dates = %w(123402003 19.9.66 0.03.1090 18/29/2014 5-23-1999)
  end

  it "has a valid factory" do
    expect(create(:date_question)).to be_valid
  end

  context "when parsing dates" do
    it "converts valid dates" do
      @dates_and_conversions.each do |d_c|
        expect(@date_question.parse(d_c["in"])).to eql(d_c["out"])
      end
    end

    it "errors on invalid dates" do
      @invalid_dates.each do |invalid_date|
        expect do
          @date_question.parse(invalid_date)
        end.to raise_error(InvalidInputError), "#{invalid_date} should fail"
      end
    end
  end

  context "when validating dates" do
    it "validates valid dates (hur)" do
      @dates_and_conversions.each do |d_c|
        expect(@date_question.valid_answer?(d_c["in"])).to be_truthy
      end
    end

    it "does not validate invalid dates" do
      @invalid_dates.each do |invalid_date|
        expect(@date_question.valid_answer?(invalid_date)).to be_falsey
      end
    end
  end
end
