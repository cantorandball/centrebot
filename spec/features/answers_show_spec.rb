require "spec_helper"

describe "View answers for a question", type: :feature do
  before(:each) do
    @question = create(:question, text: "Do you have an answer to this?")
    @next_question = create(:question, text: "Is this the end?")
    create(:question, text: "Archived question", archived: true)
    @outcome = create(:outcome,
                      value: "Oh yes",
                      question: @question,
                      next_question: @next_question)
    visit "/questions"
    button = find(:css, "#edit-question-" + @question.id.to_s)
    button.click
  end

  it "shows the outcome dropdown populated with the next question" do
    next_q_xpath = "//option[text()=\"#{@next_question.describe}\"]"
    expect(page).to have_xpath(next_q_xpath, visible: true)
  end

  it "doesn't show the default message" do
    first_dropdown_xpath = "//select[@name='question[outcomes_attributes]"\
                           "[0][next_question_id]']"
    first_dropdown = first(:xpath, first_dropdown_xpath)
    expect(first_dropdown.text).not_to eql("Select a question")
  end

  it "doesn't show archived questions" do
    first_dropdown_xpath = "//select[@name='question[outcomes_attributes]"\
                           "[0][next_question_id]']"
    first_dropdown = first(:xpath, first_dropdown_xpath)
    expect(first_dropdown).not_to have_text("Archived question")
  end
end
