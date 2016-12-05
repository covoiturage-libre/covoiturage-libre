class SearchController < ApplicationController
  
  def index
    load_index_meta_data

    @search = Search.new(search_params)
    @trips ||= []
    if @search.valid?
      found_trips = Trip.search(@search)
      @trips = Trip.includes(:points).find(found_trips.map &:id)
    end
  end

  private

    def search_params
      params.require(:search).permit(:from_city, :from_lon, :from_lat, :to_city, :to_lon, :to_lat, :date)
    end

    def load_index_meta_data
      # meta data
      @meta[:title] = 'Covoiturage Libre | Recherche'
      @meta[:description] = 'Trouver un covoiturage gratuit'
      @meta[:description] << " de #{search_params[:from_city]}" if search_params[:from_city].present?
      @meta[:description] << " à #{search_params[:to_city]}"    if search_params[:to_city].present?
      @meta[:description] << " le #{search_params[:date]}"      if search_params[:date].present?
    end

end