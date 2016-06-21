require "rails_helper"

RSpec.describe DateQuestion do
  it "has a valid factory" do
    expect(create(:date_question)).to be_valid
  end
end
