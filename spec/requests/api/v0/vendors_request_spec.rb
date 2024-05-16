require "rails_helper"

RSpec.describe "Vendors API" do
  describe "User Story 4" do
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
  end

  describe "User Story 5" do
    it "can create a new vendor" do
      vendor_params = ({
                      name: 'Murder Inc.',
                      description: 'Filled with suspense.',
                      contact_name: 'Mira',
                      contact_phone: '730-555-4435',
                      credit_accepted: true
                    })
      headers = {"CONTENT_TYPE" => "application/json"}
    
      # We include this header to make sure that these params are passed as JSON rather than as plain text
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last

      # binding.pry
      expect(response).to be_successful
      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
    end
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

    it "will vaildate contact name and contact number" do
      vendor_params = ({
                      name: 'Murder Inc.',
                      description: 'Filled with suspense.',
                      contact_name: '',
                      contact_phone: '',
                      credit_accepted: true
                    })
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:errors].first[:title]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
    end
  end
end