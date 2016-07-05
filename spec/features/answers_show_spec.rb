require "spec_helper"

describe "View answers for a question", type: :feature do
  before(:each) do
    @question = create(:question, text: "Do you have an answer to this?")
    @outcome = create(:outcome, value: 'Oh yes')
    visit "/questions"
    button = find(:css, "#edit-question-" + @question.id.to_s)
    button.click
  end
end
