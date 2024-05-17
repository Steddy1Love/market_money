class Api::V0::MarketVendorsController < ApplicationController
  
  def create
    # Check for presence of required parameters
    if params[:market_vendor].blank? || params[:market_vendor][:market_id].blank? || params[:market_vendor][:vendor_id].blank?
      render json: { error: "market_id and vendor_id are required" }, status: :bad_request
    end

    begin
      # Find the Market and Vendor
      market = Market.find(id: params[:market_vendor][:market_id])
      vendor = Vendor.find(id: params[:market_vendor][:vendor_id])
      
      # Check if the MarketVendor association already exists
      existing_association = MarketVendor.find_by(market_id: market.id, vendor_id: vendor.id)
      if existing_association
        render json: { error: "MarketVendor association already exists" }, status: :unprocessable_entity
      end

      # Create the MarketVendor association
      market_vendor = MarketVendor.new(market: market, vendor: vendor)
      if market_vendor.save
        render json: { message: "Successfully added vendor to market" }, status: :created
      else
        render json: { error: market_vendor.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.new(ErrorMessage.new(e.message)).serialize_json, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: ErrorSerializer.new(ErrorMessage.new(e.message)).serialize_json, status: :not_found
    rescue ActionController::ParameterMissing => e
      render json: ErrorSerializer.new(ErrorMessage.new(e.message)).serialize_json, status: :bad_request
    end
  end
end
  def destroy
    begin
      market_vendor = MarketVendor.find_by!(market_vendor_params)  
      market_vendor.destroy
  
      render json: market_vendor
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(ErrorMessage.new("No MarketVendor with market_id=#{market_vendor_params[:market_id]} AND vendor_id=#{market_vendor_params[:vendor_id]} exists", 404)).serialize_json, status: :not_found
    end
  end

  private

  def market_vendor_params
    params.require(:vendor).permit(:market_id, :vendor_id)
  end

end
