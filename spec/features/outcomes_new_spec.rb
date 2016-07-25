require "spec_helper"

describe "Add answer to existing question", type: :feature do
  before(:each) do
    @question = create(:question, text: "Is grass green?")
    @second_question = create(:question, text: "Do I exist?")
    @outcome = create(:outcome, question: @question, message: "Show me")
    visit "/questions"
    button = find(:css, "#edit-question-" + @question.id.to_s)
    button.click
  end

  it "has a link to create an answer" do
    expect(page).to have_content "New Answer"
  end

  it "can add a new answer" do
    within ".create-answer" do
      fill_in "question_outcomes_attributes_0_value", with: "Yes"
    end
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
    not_expected = @question.id.to_s + ": " + @question.text
    expect(page).not_to have_content not_expected
  end

  context "when editing conclusions" do
    it "shows existing conclusions" do
      expect(page).to have_text(@outcome.message)
    end

    it "saves added conclusions to the outcome" do
      within ".update-answer" do
        fill_in "question_outcomes_attributes_0_message", with: "Budgie!"
      end
      click_on "Update question"

      expect(page).to have_text("Budgie!")
      expect(@question.outcomes.first.message).to eq("Budgie!")
    end
  end

  context "When the question is a DateQuestion" do
    before(:each) do
      @date_question = create(:date_question)
      visit "/questions"
      find(:css, "#edit-question-" + @date_question.id.to_s).click
    end

    it "creates date outcomes" do
      click_on("Add answer")
      expect(@date_question.outcomes.size).to eq 1
      expect(@date_question.outcomes.first).to be_a(DateOutcome)
    end
  end
end
