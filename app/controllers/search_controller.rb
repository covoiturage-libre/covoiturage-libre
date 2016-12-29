class SearchController < ApplicationController
  
  def index
    load_index_meta_data
    params.permit!
    params[:search] ||= {}

    @trips ||= []
    @search = Search.new(params[:search])
    if @search.valid?
      if @search.from_lon.present? && @search.to_lon.present?
        @trips = Trip
                   .unscoped
                   .includes(:points)
                   .from_to(@search.from_lon, @search.from_lat, @search.to_lon, @search.to_lat)
                   .order(departure_date: :asc)
                   .order(departure_time: :asc)
                   .where(state: 'confirmed')
                   .where('departure_date >= ?', @search.date_value)
                   .page(params[:page]).per(10)
      elsif @search.from_lon.present?
        @trips = Trip
                   .unscoped
                   .includes(:points)
                   .from_only(@search.from_lon, @search.from_lat)
                   .order(departure_date: :asc)
                   .order(departure_time: :asc)
                   .where(state: 'confirmed')
                   .where('departure_date >= ?', @search.date_value)
                   .page(params[:page]).per(10)
      elsif @search.to_lon.present?
        @trips = Trip
                   .unscoped
                   .includes(:points)
                   .to_only(@search.to_lon, @search.to_lat)
                   .order(departure_date: :asc)
                   .order(departure_time: :asc)
                   .where(state: 'confirmed')
                   .where('departure_date >= ?', @search.date_value)
                   .page(params[:page]).per(10)
      end
    end
  end

  private

    def search_params
      #params.require(:search).permit(:from_city, :from_lon, :from_lat, :to_city, :to_lon, :to_lat, :date)
    end

    def load_index_meta_data
      # meta data
      @meta[:title] = 'Covoiturage-libre.fr, rechercher une annonce de covoiturage'
      @meta[:description] = 'Recherchez une annonce de covoiturage parmis toutes les annonces sans frais et faites de la vraie économie du partage, covoiturez gratuitement et librement'
      #@meta[:description] << " de #{search_params[:from_city]}" if search_params[:from_city].present?
      #@meta[:description] << " à #{search_params[:to_city]}"    if search_params[:to_city].present?
      #@meta[:description] << " le #{search_params[:date]}"      if search_params[:date].present?
    end
end