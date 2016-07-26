require "spec_helper"

describe "Edit question", type: :feature do
  before(:each) do
    @questions = [
      create(:question,
             text: "What is your favourite colour?",
             type: "MultipleChoiceQuestion"),
      create(:question, text: "What is your name?"),
    ]

    visit "/questions"
    button = find(:css, "#edit-question-" + @questions[0].id.to_s)
    button.click
  end

  it "displays the edit page" do
    expect(page).to have_text "Edit question"
  end

  context "When selecting outcomes" do
    it "displays a dropdown" do
      expect(page).to have_text("No next question")
    end
  end
end
