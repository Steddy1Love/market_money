class Api::V0::MarketsController < ApplicationController
  def index
    render json: Market.all, status: :ok
  end

  def show
    begin 
      render json: Market.find(params[:id]), status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}"}]}, status: :not_found
    end
  end
end