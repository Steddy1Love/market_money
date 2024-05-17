require "rails_helper"

RSpec.describe "Market Vendors API", type: :request do
  describe "User Story 9" do
    it "can destroy a market_vendor" do
      market_id = create(:market).id
      vendor_id = create(:vendor).id
      market_vendor = create(:market_vendor, market_id: market_id, vendor_id: vendor_id)
      expect(MarketVendor.count).to eq(1)
      market_vendor_params = {
        market_id: market_id,
        vendor_id: vendor_id
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(vendor: market_vendor_params)
    
      expect(response).to be_successful
      expect(MarketVendor.count).to eq(0)
      expect{MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "sad paths" do
    it "will gracefully handle if a market id and/or vendor id doesn't exist" do
      market_vendor = create(:market_vendor)

      market_vendor_params = {
        market_id: -1,
        vendor_id: -1
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(vendor: market_vendor_params)
    
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("No MarketVendor with market_id=-1 AND vendor_id=-1 exists")
    end
  end
end