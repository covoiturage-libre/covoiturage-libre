class CitiesController < ApplicationController

  # Top fr cities by population
  # source: https://www.insee.fr/fr/statistiques/2569312?sommaire=2587886&q=population+villes
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
      boost_where: { name: MAIN_CITIES, 
        country_code: { value: 'FR', factor: 5 } },
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
