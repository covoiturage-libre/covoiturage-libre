class CitiesController < ApplicationController

  def autocomplete
    @results = City.search(
      params[:term],
      limit: 5,
      boost_where: {country_code: {value: 'FR', factor: 5}},
      fields: [:name, :postal_code],
      match: params[:term].to_i > 0 ? :word : :word_start,
      highlight: true
    )
  end

end
