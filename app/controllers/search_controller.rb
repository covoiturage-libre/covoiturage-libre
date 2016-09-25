class SearchController < ApplicationController

  def index
    @search = Search.new(search_params)

  end

  private

    def search_params
      params.require(:search).permit(:from_name, :from_coordinates, :to_name, :to_coordinates, :date)
    end


end