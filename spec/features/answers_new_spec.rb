require "spec_helper"

describe "Add answer to existing question", type: :feature do
  before(:each) do
    @question = create(:question, text: "Is grass green?")
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
end
