require "rails_helper"

RSpec.describe "Markets API", type: :request do
  it "sends a list of markets" do
    create_list(:market, 3)

    get '/api/v0/markets'

    expect(response).to be_successful
 
    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets.count).to eq(3)

    markets.each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(Integer)

      expect(market).to have_key(:name)
      expect(market[:name]).to be_a(String)

      expect(market).to have_key(:street)
      expect(market[:street]).to be_a(String)

      expect(market).to have_key(:city)
      expect(market[:city]).to be_a(String)

      expect(market).to have_key(:county)
      expect(market[:county]).to be_a(String)

      expect(market).to have_key(:zip)
      expect(market[:zip]).to be_a(String)

      expect(market).to have_key(:lat)
      expect(market[:lat]).to be_a(String)

      expect(market).to have_key(:lon)
      expect(market[:lon]).to be_a(String)

      expect(market).to have_key(:state)
      expect(market[:state]).to be_a(String)
    end
  end

  it "can get one market by its id" do
    id = create(:market).id

    get "/api/v0/markets/#{id}"

    market = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(market).to have_key(:id)
    expect(market[:id]).to be_an(Integer)

    expect(market).to have_key(:name)
    expect(market[:name]).to be_a(String)

    expect(market).to have_key(:street)
    expect(market[:street]).to be_a(String)

    expect(market).to have_key(:city)
    expect(market[:city]).to be_a(String)

    expect(market).to have_key(:county)
    expect(market[:county]).to be_a(String)

    expect(market).to have_key(:zip)
    expect(market[:zip]).to be_a(String)

    expect(market).to have_key(:lat)
    expect(market[:lat]).to be_a(String)

    expect(market).to have_key(:lon)
    expect(market[:lon]).to be_a(String)
    
    expect(market).to have_key(:state)
    expect(market[:state]).to be_a(String)
  end

  it "can show error if exception is raised" do
    id_fail = 123123123
    id_true = create(:market).id

    get "/api/v0/markets/#{id_fail}"

    message = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful

    expect(message[:errors]).to be_an(Array)
    expect(message[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=#{id_fail}")

  end

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