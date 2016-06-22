require "rails_helper"

RSpec.describe "API Root" do
  before do
    Rails.application.routes.draw do
      get "/api/v1/test" => "test#index"
    end
  end

  after do
    Rails.application.reload_routes!
  end

  it "gives the root of the api" do
    get "/api/v1/test"

    expect(response).to be_a_success
    expect(response.body).to eq "Hello"
  end

  TestController = Class.new(Api::V1::BaseController) do
    def index
      render text: "Hello"
    end
  end
end
