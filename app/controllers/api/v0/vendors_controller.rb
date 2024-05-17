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
      render json: ErrorSerializer.new(ErrorMessage.new(e.message)).serialize_json, status: :not_found
    end
  end

  def show
    begin
      render json: Vendor.find(params[:id]) 
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message)).serialize_json, status: :not_found
    end
  end

  def create #find correct status. (refactor)
    begin
      vendor = Vendor.new(vendor_params)
      vendor.save!
  
      render json: vendor    
    rescue ActiveRecord::RecordInvalid => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message)).serialize_json, status: :bad_request
    end
  end

  def update
    begin
      vendor = Vendor.find(params[:id])
      vendor.update!(vendor_params)
  
      render json: vendor
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message)).serialize_json, status: :not_found

    rescue ActiveRecord::RecordInvalid => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message)).serialize_json, status: :bad_request
    end
  end

  def destroy
    begin
      vendor = Vendor.find(params[:id])
      vendor.destroy

      head :no_content
    rescue ActiveRecord::RecordNotFound => e
      render json:  ErrorSerializer.new(ErrorMessage.new(e.message)).serialize_json, status: :not_found
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end