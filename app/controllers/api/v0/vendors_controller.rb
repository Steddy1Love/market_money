class Api::V0::VendorsController < ApplicationController
  def index
    market = Market.find(params[:market_id])

    begin
      vendors_data = vendors.map do |vendor|
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
            detail: "Couldn't find Market with 'id'=#{market.id}"
        }]}
    end
  end
end