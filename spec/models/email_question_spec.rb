require "rails_helper"

RSpec.describe EmailQuestion do
  it "has a valid factory" do
    expect(create(:email_question)).to be_valid
  end
end
