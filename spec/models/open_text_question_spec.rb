require "rails_helper"

RSpec.describe OpenTextQuestion do
  it "has a valid factory" do
    expect(create(:open_text_question)).to be_valid
  end
end
