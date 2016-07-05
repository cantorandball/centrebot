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
    expect(page).to have_css(".next-question", text: @next_question.text)
    expect(false)
  end
end
