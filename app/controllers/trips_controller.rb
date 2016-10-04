class TripsController < ApplicationController

  before_filter :load_trip, only: [:show]

  def show
  end

  def index
  end

  def new
    @trip = Trip.new
  end

  private

    def load_trip
      @trip = Trip.find(params[:id])
    end

end