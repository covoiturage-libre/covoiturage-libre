class GeocodesController < ApplicationController

  COUNTRY_SEARCH_LIST = 'fr,be.ch'.freeze

  def autocomplete
    @results = Geocoder.search(params[:term], countrycodes: COUNTRY_SEARCH_LIST ).select { |res| res.data['address']['city'] && res.data['address']['postcode'] }
  end

end
