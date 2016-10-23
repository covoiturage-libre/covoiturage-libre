class SearchController < ApplicationController
  
  def index
    @search = Search.new(search_params)
    if @search.valid?
      found_trips = Trip.search(
                         {
                           from_coordinates: {
                               lat: search_params[:from_coordinates].split(',').first,
                               lon: search_params[:from_coordinates].split(',').last
                           },
                           to_coordinates: {
                               lat: search_params[:to_coordinates].split(',').first,
                               lon: search_params[:to_coordinates].split(',').last
                           },
                           date: Date.parse(search_params[:date], 'dd/mm/yyyy')
                         }
      )
      # TODO don't use AR, don't hit the pg db to get the data
      @trips = Trip.includes(:points).find(found_trips.map &:id)
    else
      @trips ||= []
      @search = Search.new
    end
  end

  private

    def search_params
      params.require(:search).permit(:from_name, :from_coordinates, :to_name, :to_coordinates, :date)
    end


end