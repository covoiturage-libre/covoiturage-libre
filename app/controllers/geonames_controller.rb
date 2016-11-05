class GeonamesController < ApplicationController

  def autocomplete
    @results = Geoname.search(params[:term], fields: [{place_name: :word_start}], limit: 10)
  end

end
