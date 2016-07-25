require "rails_helper"

RSpec.describe DateOutcome do
  it "has a valid factory" do
    expect(create(:date_outcome)).to be_valid
  end

  context "When validating against a date" do
    before(:each) do
      @date_question = create(:date_question)
      @less_than_outcome = create(:date_outcome,
                                  value: nil,
                                  question: @date_question,
                                  upper_bound: 4)
      @more_than_outcome = create(:date_outcome,
                                  value: nil,
                                  question: @date_question,
                                  lower_bound: 1)
      @between_outcome = create(:date_outcome,
                                value: nil,
                                question: @date_question,
                                lower_bound: 3,
                                upper_bound: 2)
      @any_outcome = create(:date_outcome,
                            value: nil,
                            question: @date_question)
    end

    it "parses 'less than' correctly" do
      five_years = Date.today.prev_year(5).strftime("%d.%m.%Y")
      one_year = Date.today.prev_year(1).strftime("%d.%m.%Y")
      expect(@date_question.outcome_for(five_years)).to eq(@less_than_outcome)
      expect(@date_question.outcome_for(one_year)).not_to eq(@less_than_outcome)
    end
  end
end
