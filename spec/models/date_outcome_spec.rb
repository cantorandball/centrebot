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
                                  lower_bound: 2)
      @between_outcome = create(:date_outcome,
                                value: nil,
                                question: @date_question,
                                lower_bound: 3,
                                upper_bound: 2)
      @any_outcome = create(:date_outcome,
                            value: nil,
                            question: @date_question)
      @five_years = Date.today.prev_year(5).strftime("%d.%m.%Y")
      @one_year = Date.today.prev_year(1).strftime("%d.%m.%Y")
    end

    it "parses 'less than' correctly" do
      expect(@date_question.outcome_for(@five_years)).to eq(@less_than_outcome)
      expect(@date_question.outcome_for(@one_year)).
        not_to eq(@less_than_outcome)
    end

    it "parses 'more than' correctly" do
      expect(@date_question.outcome_for(@one_year)).to eq(@more_than_outcome)
      expect(@date_question.outcome_for(@five_years)).
        not_to eq(@more_than_outcome)
    end

    it "parses 'between' correctly" do
      two_and_a_bit = Date.today.prev_year(2).prev_month(3).strftime("%d.%m.%Y")

      expect(@date_question.outcome_for(two_and_a_bit)).
        to eq(@between_outcome)
      expect(@date_question.outcome_for(@five_years)).
        not_to eq(@between_outcome)
    end

    it "favours the lower bound if there's a clash" do
      two_years = Date.today.prev_year(2).strftime("%d.%m.%Y")
      expect(@date_question.outcome_for(two_years)).
        to eq(@between_outcome)
    end

    it "picks the 'any valid date' response if an uncovered date is received" do
      over_three = Date.today.prev_year(3).prev_month(3).strftime("%d.%m.%Y")
      expect(@date_question.outcome_for(over_three)).
        to eq(@any_outcome)
    end
  end
end
