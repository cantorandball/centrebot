require "rails_helper"

RSpec.describe Outcome do
  it "has a valid factory" do
    expect(create(:outcome)).to be_valid
  end

  it "belongs to a question" do
    outcome = create(:outcome)
    expect(outcome.question).to be_a(Question)
  end

  it "has an emergency responder reset keyword" do
    expect(Outcome::ResetKeyword).to eq("restart")
  end

  context "when having a further question" do
    it "has a next question" do
      outcome = create(:outcome, :next_question)

      expect(outcome.next_question).to be_a(Question)
    end
  end

  context "when attached to an open text question" do
    it "is valid without text" do
      expect(build(:outcome, value: nil)).to be_valid
    end
  end

  it "it invalid with value longer than 140 characters" do
    long_message = "This is a long message which should not be valid. " \
    "Especially because it is overly wordy and doesn’t really tell you " \
    "anything. Like, at all, really."

    expect(build(:outcome, value: long_message)).not_to be_valid
  end

  it "is invalid if the end message is longer than 140 characters" do
    long_message = "This is a long message which should not be valid. " \
    "Especially because it is overly wordy and doesn’t really tell you " \
    "anything. Like, at all, really."

    expect(build(:outcome, message: long_message)).not_to be_valid
  end
end
