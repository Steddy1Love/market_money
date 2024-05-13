class Api::V1::MarketsController < ApplicationController
  def index
    render json: Market.all
  end
end