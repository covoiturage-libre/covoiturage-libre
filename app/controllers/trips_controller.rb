class TripsController < ApplicationController

  def new
    @trip = Trip.new
  end

end