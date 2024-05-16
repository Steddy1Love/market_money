class Api::V0::VendorsController < ApplicationController
  def index
    begin
      market = Market.find(params[:market_id])
      vendors_data = market.vendors.map do |vendor|
        {
          id: vendor.id,
          name: vendor.name,
          description: vendor.description,
          contact_name: vendor.contact_name,
          contact_phone: vendor.contact_phone,
          credit_accepted: vendor.credit_accepted
        }
      end
      render json: { data: vendors_data }, status: :ok
    rescue StandardError => e
      render json: { errors: [{
            detail: "Couldn't find Market with 'id'=#{params[:market_id]}"
        }]}, status: :not_found
    end
  end
end