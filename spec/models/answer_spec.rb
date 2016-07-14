require "rails_helper"

RSpec.describe Answer do
  it "has a valid factory" do
    expect(create(:answer)).to be_valid
  end

  it "is valid without text" do
    expect(create(:answer, text: nil)).to be_valid
  end

  it "is not valid without question_text" do
    expect(build(:answer, question_text: nil)).not_to be_valid
  end

  it "has a question" do
    answer = create(:answer)

    expect(answer.question).to be_a(Question)
  end

  it "has a responder" do
    answer = create(:answer)

    expect(answer.responder).to be_a(Responder)
  end

  it "records changes in question text" do
    responder = create(:responder)
    first_text = "Where do you live?"
    second_text = "Where DON'T you live?"

    changing_question = create(:question, text: first_text)
    first_answer = changing_question.answer(responder, "Bristol")

    changing_question.update_attribute(:text, second_text)
    second_answer = changing_question.answer(responder, "Not Bristol")

    expect(responder.answers.length).to eq(2)
    expect(first_answer.question).to eq(second_answer.question)
    expect(first_answer.question_text).to eq(first_text)
    expect(second_answer.question_text).to eq(second_text)
  end
end
