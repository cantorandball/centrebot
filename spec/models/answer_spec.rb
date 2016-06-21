require "rails_helper"

RSpec.describe Answer do
  it "has a valid factory" do
    expect(create(:answer)).to be_valid
  end

  it "is valid without text" do
    expect(create(:answer, text: nil)).to be_valid
  end

  it "has a question" do
    answer = create(:answer)

    expect(answer.question).to be_a(Question)
  end

  it "has a responder" do
    answer = create(:answer)

    expect(answer.responder).to be_a(Responder)
  end
end
