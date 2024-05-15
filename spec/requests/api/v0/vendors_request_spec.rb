require "rails_helper"

RSpec.describe "Vendor API", type: :request do
  it "can show all vendors for a market" do
    market1 = create(:market)
    market2 = create(:market)
    create_list(:market_vendor, 4)
    create_list(:vendor, 3)
    
    id = market1.id

    get "/api/v0/markets/#{id}/vendors"

    message = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    binding.pry
    expect(message)
  end
end