class SearchController < ApplicationController

  def index
    load_index_meta_data

    @trips ||= []
    @search = Search.new(search_params)
    if @search.valid?
      if @search.from_lon.present? && @search.to_lon.present?
        @trips = Trip
                   .unscoped
                   .includes(:points)
                   .where('departure_date >= ?', @search.date_value)
                   .where(state: 'confirmed')
                   .from_to(
                      @search.from_lon, @search.from_lat,
                      @search.to_lon, @search.to_lat,
                      @search.from_dist, @search.to_dist
                    )
                   .order(departure_date: :asc)
                   .order(departure_time: :asc)
                   .page(params[:page]).per(10)
      elsif @search.from_lon.present?
        @trips = Trip
                   .unscoped
                   .includes(:points)
                   .where('departure_date >= ?', @search.date_value)
                   .where(state: 'confirmed')
                   .from_only(
                      @search.from_lon, @search.from_lat,
                      @search.from_dist
                    )
                   .order(departure_date: :asc)
                   .order(departure_time: :asc)
                   .page(params[:page]).per(10)
      elsif @search.to_lon.present?
        @trips = Trip
                   .unscoped
                   .includes(:points)
                   .where('departure_date >= ?', @search.date_value)
                   .where(state: 'confirmed')
                   .to_only(
                      @search.to_lon, @search.to_lat,
                      @search.to_dist
                    )
                   .order(departure_date: :asc)
                   .order(departure_time: :asc)
                   .page(params[:page]).per(10)
      end
    end
  end

  private

    def search_params
      params.permit!
      params[:search] || {}

      # params.require(:search).permit(
      #   :from_city, :from_lon, :from_lat, :from_dist,
      #   :to_city, :to_lon, :to_lat, :to_dist,
      #   :date
      # )
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
