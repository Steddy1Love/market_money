class Api::V0::MarketVendorsController < ApplicationController
  def destroy
    market_vendor = MarketVendor.find(params[:id])
    market_vendor.destroy

    render json: market_vendor
  end
end