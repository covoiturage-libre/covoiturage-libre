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
    Lille
    Rennes
    Reims
    Le Havre
    Saint-Étienne
    Toulon
    Grenoble
    Dijon
    Nîmes
    Angers
    Villeurbanne
    Saint-Denis
    Le Mans
    Aix-en-Provence
    Clermont-Ferrand
    Brest
    Tours
    Limoges
    Amiens
    Perpignan
    Metz
    Boulogne-Billancourt
    Besançon
    Orléans
    Mulhouse
    Saint-Denis
    Rouen
    Argenteuil
    Caen
    Montreuil
    Saint-Paul
    Nancy
    Roubaix
    Tourcoing
    Nanterre
    Avignon
    Vitry-sur-Seine
    Créteil
    Dunkerque
    Poitiers
    Asnières-sur-Seine
    Versailles
    Courbevoie
    Colombes
    Fort-de-France
    Aulnay-sous-Bois
    Saint-Pierre
    Cherbourg-en-Cotentin
    Aubervilliers
    Rueil-Malmaison
    Pau
    Le Tampon
    Champigny-sur-Marne
    Calais
    Antibes
    Béziers
    Saint-Maur-des-Fossés
    La Rochelle
    Cannes
    Saint-Nazaire
    Mérignac
    Drancy
    Colmar
    Ajaccio
    Issy-les-Moulineaux
    Bourges
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
                   .sort_by{ |city| MAIN_CITIES.index city.name }[0, 5]
    render 'autocomplete'
  end

end
