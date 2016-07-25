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
    expect(page).to have_text("Any valid date")
  end
end
