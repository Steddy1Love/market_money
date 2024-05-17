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
      post "/api/v0/market_vendors", params: JSON.generate(market_vendor: market_vendor_params)
      created_association = MarketVendor.last

      expect(response).to be_successful
      expect(created_association.market_id).to eq(market1.id)
      expect(created_association.vendor_id).to eq(vendor2.id)
    end
  end

  describe "Sad paths" do
    xit "Endpoint 8 sad path 1" do
      vendor = create(:vendor)
      market_vendor_params = ({
        market_id: 123123123,
        vendor_id: vendor.id
      })

      post "/api/v0/market_vendors", params: JSON.generate
    end
  end
end
