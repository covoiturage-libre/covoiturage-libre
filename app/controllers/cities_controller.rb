class CitiesController < ApplicationController

  # TOP 10 FR by population
  MAIN_CITIES = %w(
    Paris
    Marseille
    Bruxelles
    Lyon
    Toulouse
    Nice
    Nantes
    Strasbourg
    Montpellier
    Bordeaux
  )

  def autocomplete
    @results = City.search(
      params[:term],
      limit: 5,
      boost_where: { country_code: { value: 'FR', factor: 5 } },
      fields: [:name, :postal_code],
      match: params[:term].to_i > 0 ? :word : :word_start,
      highlight: true
    )
  end

  def main
    @results = City.where(name: MAIN_CITIES)
                   .sort_by{ |city| MAIN_CITIES.index city.name }
    render 'autocomplete'
  end

end
