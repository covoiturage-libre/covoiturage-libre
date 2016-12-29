class LandingController < ApplicationController

  def index
    load_index_meta_data

    @search = Search.new(build_params).complete_missing_params
    @trips ||= []
    if @search.valid?
      found_trips = Trip.search(@search)
      @trips = Trip.includes(:points).find(found_trips.map &:id)
    end

    render 'search/index'
  end

  private

  def load_index_meta_data
    # meta data
    @meta[:title] = "Covoiturage Libre #{params[:from]} - #{params[:to]}"
    @meta[:description] = "Covoiturages libres et gratuit de #{params[:from]} à #{params[:to]}"
  end


  def search_cities
    @from_city = City.search(params[:from], limit: 1).first if params[:from].present?
    @to_city = City.search(params[:to], limit: 1).first if params[:to].present?
  end

  def build_params
    search_cities
    {
      from_city: @from_city.name,
      from_lon: @from_city.lon,
      from_lat: @from_city.lat,
      to_city: @to_city.name,
      to_lon: @to_city.lon,
      to_lat: @to_city.lat,
    }
  end

end