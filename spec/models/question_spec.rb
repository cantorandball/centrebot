require "rails_helper"

RSpec.describe Question do
  it "has a valid factory" do
    expect(create(:question)).to be_valid
  end

  it "is invalid without text" do
    expect(build(:question, text: nil)).not_to be_valid
  end

  it "it invalid with text longer than 140 characters" do
    long_message = "This is a long message which should not be valid. " \
      "Especially because it is overly wordy and doesn’t really tell you " \
      "anything. Like, at all, really."

    expect(build(:question, text: long_message)).not_to be_valid
  end
end
