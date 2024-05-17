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

  describe "User Story 6" do
    it "can update an existing vendor" do
      id = create(:vendor).id
      previous_name = Vendor.last.name
      vendor_params = { name: "Charlotte's Web" }
      headers = {"CONTENT_TYPE" => "application/json"}
    
      # We include this header to make sure that these params are passed as JSON rather than as plain text
      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      vendor = Vendor.find_by(id: id)
    
      expect(response).to be_successful
      expect(vendor.name).to_not eq(previous_name)
      expect(vendor.name).to eq("Charlotte's Web")
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
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:errors].first[:title]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
    end

    it "will gracefully handle if a vendor id doesn't exist update" do
      vendor_params = { name: "Charlotte's Web" }
      headers = {"CONTENT_TYPE" => "application/json"}
    
      # We include this header to make sure that these params are passed as JSON rather than as plain text
      patch "/api/v0/vendors/1", headers: headers, params: JSON.generate({vendor: vendor_params})

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=1")
    end

    it "will vaildate contact name update" do
      id = create(:vendor).id
      vendor_params = ({
                      name: 'Murder Inc.',
                      description: 'Filled with suspense.',
                      contact_name: '',
                      contact_phone: '720-888-9988',
                      credit_accepted: false
                    })
      headers = {"CONTENT_TYPE" => "application/json"}
      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:errors].first[:title]).to eq("Validation failed: Contact name can't be blank")
    end
  end
end