class SearchController < ApplicationController
  def index
    hash_result = MasService.new(params[:term]).search

    render json: hash_result
  end
end

