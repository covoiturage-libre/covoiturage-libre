class SearchController < ApplicationController

  def index
    @search = Search.new(search_params)

  end

  private

    def search_params
      params.require(:search).permit(:from, :from_coordinates, :to, :to_coordinates, :date)
    end


end