class SearchController < ApplicationController


  def index
    @search = Search.new(search_params)
    if @search.valid?
      response = Trip.search(
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
      @trips = response.records.to_a
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