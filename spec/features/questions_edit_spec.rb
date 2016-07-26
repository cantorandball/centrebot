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

  it "displays a tag if it's present" do
    tagged_question = create(:question, tag: "Section 1 Q7")

    visit "/questions"
    button = find(:css, "#edit-question-" + tagged_question.id.to_s)
    button.click

    expect(page).to have_text("Question name")
    expect(find_field("question_tag").value).to eq(tagged_question.tag)
  end

  it "displays the question id if no tag is present" do
    tagged_question = create(:question)

    visit "/questions"
    button = find(:css, "#edit-question-" + tagged_question.id.to_s)
    button.click

    expect(page).to have_text("Question name")
    expect(find_field("question_tag").value).to eq(tagged_question.id.to_s)
  end
end
