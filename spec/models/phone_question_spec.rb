require "rails_helper"

RSpec.describe PhoneQuestion do
  it "has a valid factory" do
    expect(create(:phone_question)).to be_valid
  end
end
