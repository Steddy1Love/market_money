class Api::V0::VendorsController < ApplicationController
  def index
    render json: Vendor.all
  end

  def show
    render json: Vendor.find(params[:id])
  end
end