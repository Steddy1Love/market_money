require "rails_helper"

RSpec.describe "Vendors API" do
  it "can get one vendor by its id" do
    id = create(:vendor).id

    get "/api/v0/vendors/#{id}"

    vendor = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(vendor).to have_key(:id)
    expect(vendor[:id]).to be_an(Integer)

    expect(vendor).to have_key(:name)
    expect(vendor[:name]).to be_a(String)

    expect(vendor).to have_key(:description)
    expect(vendor[:description]).to be_a(String)

    expect(vendor).to have_key(:contact_name)
    expect(vendor[:contact_name]).to be_a(String)

    expect(vendor).to have_key(:contact_phone)
    expect(vendor[:contact_phone]).to be_a(String)

    expect(vendor).to have_key(:credit_accepted)
    expect([TrueClass, FalseClass]).to include(vendor[:credit_accepted].class)
  end

  describe 'sad paths' do
    it "will gracefully handle if a vendor id doesn't exist" do
      get "/api/v0/vendors/1"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=1")
    end
  end
end