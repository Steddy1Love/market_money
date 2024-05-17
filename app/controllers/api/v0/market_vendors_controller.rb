class Api::V0::MarketVendorsController < ApplicationController
  
  def create
    # Check for presence of required parameters
    if params[:market_id].blank? || params[:vendor_id].blank?
      return render json: { error: "market_id and vendor_id are required" }, status: :bad_request
    end
    
    begin
    # Find the Market and Vendor
    market = Market.find_by!(id: params[:market_id])
    vendor = Vendor.find_by!(id: params[:vendor_id])
    
    rescue ActiveRecord::ValidationError => e
      binding.pry
      render json: ErrorSerializer.new(ErrorMessage.new(e.message)).serialize_json, status: :bad_request
    end
    # Check if market or vendor does not exist
    if market.nil?
      return render json: { error: "Market not found" }, status: :not_found
    end

    if vendor.nil?
      return render json: { error: "Vendor not found" }, status: :not_found
    end

    # Check if the MarketVendor association already exists
    existing_association = MarketVendor.find_by(market_id: market.id, vendor_id: vendor.id)
    if existing_association
      return render json: { error: "MarketVendor association already exists" }, status: :unprocessable_entity
    end

    # Create the MarketVendor association
    market_vendor = MarketVendor.new(market: market, vendor: vendor)

    if market_vendor.save
      render json: { message: "Successfully added vendor to market" }, status: :created
    else
      render json: { error: market_vendor.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end
end
