require "spec_helper"

describe "Questions index", type: :feature do
  before(:each) do
    @questions = [
      create(:question, text: "What is your favourite colour?",
             type: "MultipleChoiceQuestion"),
      create(:question, text: "What is your name?")
    ]

    visit "/questions"
  end

  it "displays how many questions exists" do
    expect(page).to have_text Question.all.count
  end

  it "displays the questions in a list" do
    expect(page).to have_text "Questions"
    expect(page).to have_text @questions[0].text
    expect(page).to have_text @questions[1].text
  end

  it "displays a button to edit each question" do
    button = find(:css, "#edit-question-" + @questions[0].id.to_s)
    expect(button).to have_text "Edit question"
  end

  it "displays each questions type" do
    expect(page).to have_text "Multiple Choice Question"
  end

  it "has a button to create a new question" do
    expect(page).to have_text "Add a new question"
  end
end
