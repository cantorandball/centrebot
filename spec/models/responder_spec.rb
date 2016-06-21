require "rails_helper"

RSpec.describe Responder do
  it "has a valid factory" do
    expect(create(:responder)).to be_valid
  end
end
