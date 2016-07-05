require "spec_helper"

describe "View answers for a question", type: :feature do
  before(:each) do
    @question = create(:question, text: "Do you have an answer to this?")
    @next_question = create(:question, text: "Is this the end?")
    @outcome = create(:outcome, value: 'Oh yes',
                      question: @question, next_question: @next_question)
    visit "/questions"
    button = find(:css, "#edit-question-" + @question.id.to_s)
    button.click
  end

  it "shows the outcome dropdown populated with the next question" do
    next_q_xpath = "//option[text()=\"#{@next_question.text}\"]"
    expect(page).to have_xpath(next_q_xpath, visible: true)
  end

  it "doesn't show the default message" do
    default_xpath = '//option[text()="Select a question"]'
    expect(page).not_to have_xpath(default_xpath, visible: true)
  end
end
