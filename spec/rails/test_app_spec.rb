require_relative "rails_helper"

describe "Test app", type: :request do
  it("responds to /up") do
    get "/up"
    expect(response.status).to be 200
  end
end
