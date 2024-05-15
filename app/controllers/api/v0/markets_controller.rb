class Api::V0::MarketsController < ApplicationController
  def index
    render json: Market.all, status: :ok
  end

  def show
    if Market.find(params[:id]) == true
      render json: Market.find(params[:id]), status: :ok
    else
      render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}"}]}
    end
  end
end