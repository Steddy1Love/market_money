class Api::V0::MarketVendorsController < ApplicationController
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