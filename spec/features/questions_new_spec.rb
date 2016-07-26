require "spec_helper"

describe "New question", type: :feature do
  before do
    visit "/questions/new"
  end

  it "has a title to tell you where you are" do
    expect(page).to have_text "Create a new question"
  end

  it "allows the user to select a question type" do
    expect(page).to have_css("#question_type_DateQuestion")
  end

  it "has a textarea to allow the user to enter the question text" do
    expect(page).to have_css("#question_text")
  end

  it "allows the user to submit the question" do
    expect(page).to have_button "Save Question"
  end

  it "shows a flash when successful" do
    fill_in("Question text", with: "What colour is the sky?")
    click_on("Save Question")

    expect(page).to have_text "Question created"
  end

  it "allows you to name the question" do
    expect(page).to have_text("Question name")
    fill_in("Question text", with: "What colour is the sky?")
    fill_in("question_tag", with: "Section 1: Q8")
    click_on("Save Question")

    expect(Question.all.last.name).to eq("Section 1: Q8")
  end
end
