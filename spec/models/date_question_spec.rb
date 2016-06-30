require "rails_helper"

RSpec.describe DateQuestion do
  it "has a valid factory" do
    expect(create(:date_question)).to be_valid
  end

  it "parses valid dates" do
    date_question = create(:date_question)
    dates_and_conversions = []
    dates_and_conversions.push({'in' => '9/8/1989', 'out' => '09.08.1989'})
    dates_and_conversions.push({'in' => '5.3.2001', 'out' => '05.03.2001'})
    dates_and_conversions.push({'in' => '16\\11\\2003', 'out' => '16.11.2003'})
    dates_and_conversions.each do |d_c|
      expect(date_question.parse(d_c['in'])).to eql(d_c['out'])
    end
  end

  it "does not parse invalid dates" do
    date_question = create(:date_question)
    invalid_dates = %w(9.9.9 123402003 19.9.66 16^18^840.03.1090 18/29/2014)
    invalid_dates.each do |invalid_date|
      expect do
        date_question.parse(invalid_date)
      end.to raise_error(InvalidInputError)
    end
  end
end
