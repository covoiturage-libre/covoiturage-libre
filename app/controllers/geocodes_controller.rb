class GeocodesController < ApplicationController

  COUNTRY_SEARCH_LIST = 'gb,de,fr,es,be'

  def autocomplete
    render json: Geocoder.search(params[:term], params: {countrycodes: COUNTRY_SEARCH_LIST}).map(&:data)
  end

end