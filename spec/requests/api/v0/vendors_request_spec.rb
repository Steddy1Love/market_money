require "rails_helper"

RSpec.describe "Vendor API", type: :request do
  it "can show all vendors for a market" do
    market1 = create(:market)
    market2 = create(:market)
    create_list(:vendor, 3)
    create(:market_vendor, market: market1)
    create(:market_vendor, market: market2)
    
    id = market1.id

    get "/api/v0/markets/#{id}/vendors"

    message = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(message[:data]).to be_an(Array)
    expect(message[:data].first).to be_a(Hash)
  end

  it "sad path: can show an error if there is an invalid market id" do
    market1 = create(:market)
    market2 = create(:market)
    create_list(:vendor, 3)
    create(:market_vendor, market: market1)
    create(:market_vendor, market: market2)

    id = 123123123
    get "/api/v0/markets/#{id}/vendors"

    message =  JSON.parse(response.body, symbolize_names: true)
    expect(response).to_not be_successful
    expect(message[:errors]).to be_an(Array)
    expect(message[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=#{id}")
  end
end