class GeocodesController < ApplicationController

  #
  # @returns :
  #  [{ display_name: "Lille", lat: ..., lon: ...}, {}]
  #
  def autocomplete
    @results = Geocoder.search(params[:term])
  end


end