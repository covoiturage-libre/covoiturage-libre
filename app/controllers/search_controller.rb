class SearchController < ApplicationController
  
  def index
    @search = Search.new(search_params)
    @trips ||= []
    if @search.valid?
      found_trips = Trip.search(@search)
      @trips = Trip.includes(:points).find(found_trips.map &:id)
    else
      @search = Search.new
    end
  end

  private

    def search_params
      params.require(:search).permit(:from_city, :from_lon, :from_lat, :to_city, :to_lon, :to_lat, :date)
    end

end