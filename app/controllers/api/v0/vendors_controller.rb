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
end