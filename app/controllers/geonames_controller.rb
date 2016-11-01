class GeonamesController < ApplicationController

  def autocomplete
    @results = Geoname.search(params[:term])
  end

end
