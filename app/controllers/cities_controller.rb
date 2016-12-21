class CitiesController < ApplicationController

  def autocomplete
    @results = City.search(params[:term], fields: [{name: :word_start}], limit: 10)
  end

end
