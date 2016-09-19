class TripsController < ApplicationController

  def index

  end

  def new
    @trip = Trip.new
  end

end