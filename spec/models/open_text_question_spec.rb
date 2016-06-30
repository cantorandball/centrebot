require "rails_helper"

RSpec.describe OpenTextQuestion do
  it "has a valid factory" do
    expect(create(:open_text_question)).to be_valid
  end

  it "returns strings unchanged" do
    open_text_question = create(:open_text_question)
    in_message = "OH WOW ok :)"
    expect(open_text_question.parse(in_message)).to eql(in_message)
  end

  it "will accept long messages" do
    open_text_question = create(:open_text_question)
    long_message = 'blah ' * 100
    expect(open_text_question.parse(long_message)).to eql(long_message)
  end
end
