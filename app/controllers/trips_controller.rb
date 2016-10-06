class TripsController < ApplicationController

  before_filter :load_trip, only: [:show]

  def show
  end

  def index
  end

  def new
    @trip = Trip.new
    @from_point = @trip.points.build({ kind: 'From' })
    @to_point = @trip.points.build({ kind: 'To' })
    @required_points = [@from_point, @to_point]
    @optional_points = []
    3.times do
      @optional_points << @trip.points.build({ kind: 'Step' })
    end
  end

  def create

  end

  def edit

  end

  def update

  end

  private

    def load_trip
      @trip = Trip.find(params[:id])
    end

    def trip_params

    end

end