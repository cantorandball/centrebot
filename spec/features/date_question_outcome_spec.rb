require "spec_helper"

describe "Add outcome to date question", type: :feature do
  before(:each) do
    @date_question = create(:date_question)
    visit "/questions"
    button = find(:css, "#edit-question-" + @date_question.id.to_s)
    button.click
  end

  it "does not display the title 'value' for a date question" do
    expect(page).not_to have_text("Value")
  end

  it "displays options for date answers" do
    expect(page).to have_text("Earliest date")
  end

  it "saves input values for lower and upper bounds" do
    lower_id = "question_outcomes_attributes_0_lower_bound"
    upper_id = "question_outcomes_attributes_0_upper_bound"

    fill_in lower_id, with: 6
    fill_in upper_id, with: 3

    click_on "Add answer"

    expect(@date_question.outcomes.first.lower_bound).to eq(6)
    expect(@date_question.outcomes.first.upper_bound).to eq(3)
  end
end
