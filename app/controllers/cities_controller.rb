class CitiesController < ApplicationController

  # Top fr cities by population with postal codes
  # source: https://www.insee.fr/fr/statistiques/2569312?sommaire=2587886&q=population+villes
  MAIN_CITIES = [
    ["Paris", "75000"],
    ["Marseille", "13000"],
    ["Bruxelles", "1000"],
    ["Lyon", "69000"],
    ["Toulouse", "31000"],
    ["Nice", "06000"],
    ["Nantes", "44000"],
    ["Strasbourg", "67000"],
    ["Montpellier", "34000"],
    ["Bordeaux", "33000"],
    ["Lille", "59000"],
    ["Rennes", "35000"],
    ["Reims", "51100"],
    ["Le Havre", "76620"],
    ["Saint-Étienne","42100"],
    ["Toulon", "83000"],
    ["Grenoble", "38000"],
    ["Dijon", "21000"],
    ["Nîmes", "30000"],
    ["Angers", "49000"],
    ["Villeurbanne", "69100"],
    ["Saint-Denis", "93200"],
    ["Le Mans","72100"],
    ["Aix-en-Provence","13100"],
    ["Clermont-Ferrand","63000"],
    ["Brest", "29200"],
    ["Tours", "37000"],
    ["Limoges", "87000"],
    ["Amiens", "80000"],
    ["Perpignan", "66000"],
    ["Metz", "57000"],
    ["Boulogne-Billancourt","92100"],
    ["Besançon", "25000"],
    ["Orléans", "45000"],
    ["Mulhouse", "68100"],
    ["Rouen", "76000"],
    ["Argenteuil", "95100"],
    ["Caen", "14000"],
    ["Montreuil", "93100"],
    ["Nancy", "54000"],
    ["Roubaix", "59100"],
    ["Tourcoing", "59200"],
    ["Nanterre", "92000"],
    ["Avignon", "84000"],
    ["Vitry-sur-Seine","94400"],
    ["Créteil", "94000"],
    ["Dunkerque", "59240"],
    ["Poitiers", "86000"],
    ["Asnières-sur-Seine","92600"],
    ["Versailles", "78000"],
    ["Courbevoie", "92400"],
    ["Colombes", "92700"],
    ["Aulnay-sous-Bois","93600"],
    ["Cherbourg-en-Cotentin","50100"],
    ["Aubervilliers", "93300"],
    ["Rueil-Malmaison","92500"],
    ["Pau", "64000"],
    ["Champigny-sur-Marne","94500"],
    ["Calais", "62100"],
    ["Antibes", "06160"],
    ["Béziers", "34500"],
    ["Saint-Maur-des-Fossés", "94100"],
    ["La Rochelle","17000"],
    ["Cannes", "06400"],
    ["Saint-Nazaire","44600"],
    ["Mérignac", "33700"],
    ["Drancy", "93700"],
    ["Colmar", "68000"],
    ["Ajaccio", "20000"],
    ["Issy-les-Moulineaux", "92130"],
    ["Bourges", "18000"]
  ]
  # Separate names and postal codes
  MAIN_NAMES = []
  MAIN_CITIES.each{ |city| MAIN_NAMES.push(city[0]) }
  MAIN_POSTAL_CODES = []
  MAIN_CITIES.each{ |city| MAIN_POSTAL_CODES.push(city[1]) }

  def autocomplete
    @results = City.search(
      params[:term],
      limit: 5,
      boost_where: { postal_code: MAIN_POSTAL_CODES,
        country_code: { value: 'FR', factor: 5 } },
      fields: [:name, :postal_code],
      match: params[:term].to_i > 0 ? :word : :word_start,
      highlight: true
    )
  end

  def main
    @results = City.where(name: MAIN_NAMES)
                   .sort_by{ |city| MAIN_NAMES.index city.name }[0, 5]
    render 'autocomplete'
  end

end
