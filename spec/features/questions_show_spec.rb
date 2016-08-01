require "spec_helper"

describe "Questions index", type: :feature do
  before do
    @questions = [
      create(:question,
             text: "What is your favourite colour?",
             type: "MultipleChoiceQuestion"),
      create(:question, text: "What is your name?", tag: "Section 1 Q6"),
      create(:question, text: "What is your other name?", tag: "Section 1 Q5"),
      create(:question, text: "This was a bad question", archived: true),
    ]

    visit "/questions"
  end

  it "displays how many questions exists" do
    expect(page).to have_text Question.all.where(archived: false).count
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

  it "displays each question's type" do
    expect(page).to have_text "Multiple Choice Question"
  end

  it "has a button to create a new question" do
    expect(page).to have_text "Add a new question"
  end

  it "does not list archived questions" do
    expect(page).not_to have_text @questions.last.text
  end

  it "displays a button for archiving each question" do
    button = find(:css, "#archive-question-" + @questions[1].id.to_s)
    expect(button["value"]).to eq("Archive")
  end

  it "does not display a button for archiving the first question" do
    selector = "#archive-question-" + @questions[0].id.to_s
    expect(page).not_to have_selector(:css, selector)
  end

  it "displays question tags if these are present" do
    expect(page).to have_text(@questions[2].tag)
  end

  it "displays question ids if no tags are present" do
    expect(page).to have_text(@questions.first.id)
  end

  it "labels Question Names correctly" do
    expect(page).not_to have_text("Question No.")
    expect(page).to have_text("Question Name")
  end

  it "writes the question id into the every question row" do
    expect(page.all("tr")[1][:id]).to eq("question-#{@questions[0].id}")
  end

  context "In the next question column" do
    before(:each) do
      create(:outcome,
             value: "out1",
             question: @questions[0],
             next_question: @questions[1])
      create(:outcome,
             value: "another_out1",
             question: @questions[0],
             next_question: @questions[1])
      create(:outcome,
             value: "out2",
             question: @questions[0],
             next_question: @questions[2])
      visit "/questions"
      @question_rows = page.all("tr")
    end

    it "displays any next questions linked to from any outcomes" do
      expect(@question_rows[0]).to have_text("Linked questions")
      expect(@question_rows[1]).to have_text(@questions[1].name)
      expect(@question_rows[1]).to have_text(@questions[2].name)
    end

    it "does not display duplicate links" do
      expect(@question_rows[1]).to have_text(@questions[1].name, count: 1)
    end

    it "displays a warning if there are no links" do
      expect(@question_rows[2]).to have_text("No linked questions")
    end
  end
end
