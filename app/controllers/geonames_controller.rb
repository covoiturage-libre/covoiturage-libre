class GeonamesController < ApplicationController

  def autocomplete
    @results = Geoname.search(params[:term], limit: 10)
  end

end
