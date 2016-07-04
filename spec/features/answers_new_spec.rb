require "spec_helper"

describe "Add answer to existing question", type: :feature do
  before(:each) do
    @question = create(:question, text: "Is grass green?")
    @second_question = create(:question, text: "Do I exist?")
    visit "/questions"
    button = find(:css, "#edit-question-" + @question.id.to_s)
    button.click
  end

  it "has a link to create an answer" do
    expect(page).to have_content "New Answer"
  end

  it "can add a new answer" do
    fill_in "question_answers_attributes_0_text", with: "Yes"
    click_on("Add answer")
    expect(page).to have_content "Edit Answer"
    expect(page).to have_content "Yes"
  end

  it "lists other existing questions to link to" do
    dropdown = first(:css, ".form-input-full-width")
    dropdown.click
    expected = @second_question.id.to_s + ": " + @second_question.text
    expect(page).to have_content expected
  end

  it "doesn't allow you to choose the existing question as an outcome" do
    dropdown = first(:css, ".form-input-full-width")
    dropdown.click
    expected = @question.id.to_s + ": " + @question.text
    expect(page).not_to have_content expected
  end
end
