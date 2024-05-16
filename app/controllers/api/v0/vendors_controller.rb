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

  def create #find correct status. (refactor)
    begin
      vendor = Vendor.new(vendor_params)
      vendor.save!
  
      render json: vendor    
    rescue ActiveRecord::RecordInvalid => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400)).serialize_json, status: :not_found
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end