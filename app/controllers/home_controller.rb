class HomeController < ApplicationController

  def index
    @trips = Trip.eager_load(:points).order(created_at: :desc).page(params[:page])
  end

end
