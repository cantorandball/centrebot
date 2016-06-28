require "rails_helper"

RSpec.describe Outcome do
  it "has a valid factory" do
    expect(create(:outcome)).to be_valid
  end

  it "belongs to a question" do
    outcome = create(:outcome)

    expect(outcome.question).to be_a(Question)
  end

  context "when having a further question" do
    it "has a next question" do
      outcome = create(:outcome, :next_question)

      expect(outcome.next_question).to be_a(Question)
    end
  end

  it "is invalid without text" do
    expect(build(:outcome, value: nil)).not_to be_valid
  end
end
