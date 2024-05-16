class Api::V0::VendorsController < ApplicationController
  def index
    render json: Vendor.all
  end

  def show
    begin
      render json: Vendor.find(params[:id]) 
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404)).serialize_json, status: :not_found
    end
  end

  def create
    render json: Vendor.create(vendor_params)
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end