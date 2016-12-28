class CitiesController < ApplicationController

  def autocomplete
    @results = City.search(params[:term], fields: [:name], limit: 10)
  end

end
