class HomeController < ApplicationController

  def index
    @itineraries = Itinerary.eager_load(:locations).order(created_at: :desc).page(params[:page])
  end

end
