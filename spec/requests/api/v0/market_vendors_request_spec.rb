require "rails_helper"

RSpec.describe "Market Vendors API", type: :request do
  it "can destroy an market_vendor" do
    market_vendor = create(:market_vendor)
    id = market_vendor.id
  
    expect(MarketVendor.count).to eq(1)
  
    delete "/api/v0/market_vendors/#{id}"
  
    expect(response).to be_successful
    expect(MarketVendor.count).to eq(0)
    expect{MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end