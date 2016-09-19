class HomeController < ApplicationController

  def index
    @trip_search = Trip.new
  end

end
