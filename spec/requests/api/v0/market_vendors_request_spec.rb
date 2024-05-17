require 'rails_helper'

RSpec.describe "Api::V0::MarketVendors", type: :request do
  describe "Happy paths" do
    it "Endpoint 8 can create a new market vendor association" do
      market1 = create(:market)
      market2 = create(:market)
      vendor1 = create(:vendor)
      vendor2 = create(:vendor)
      market_vendor_params = ({
        market_id: market1.id,
        vendor_id: vendor2.id
      })

      post "/api/v0/market_vendors", params: { market_vendor: market_vendor_params }
      created_association = MarketVendor.last

      expect(response).to have_http_status(:created)
      expect(response).to be_successful
      expect(created_association.market_id).to eq(market1.id)
      expect(created_association.vendor_id).to eq(vendor2.id)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:message]).to eq("Successfully added vendor to market")
    end
  end

  describe "Sad paths" do
    it "Endpoint 8 sad path 1" do
      vendor = create(:vendor)
      id = 123123123
      market_vendor_params = ({
        market_id: id,
        vendor_id: vendor.id
      })

      post "/api/v0/market_vendors", params: { market_vendor: market_vendor_params }

      data = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Market with 'id'={:id=>\"#{id}\"}")
    end

    it "Endpoint 8 sad path 2" do
      vendor1 = create(:vendor)
      market1 = create(:market)
      market_vendor1 = create(:market_vendor, market: market1, vendor: vendor1)
      market_vendor_params = ({
        market_id: market1.id,
        vendor_id: vendor1.id
      })

      post "/api/v0/market_vendors", params: { market_vendor: market_vendor_params }

      data = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:detail]).to eq("Validation failed: Market vendor asociation between market with market_id=#{market1.id} and vendor_id=#{vendor1.id} already exists")
    end
  end
end
