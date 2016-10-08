class TripsController < ApplicationController

  before_filter :load_trip, only: [:show]

  def show
  end

  def index
  end

  def new
    @trip = Trip.new
    @point_from = @trip.points.build({ kind: 'From' })
    @point_to = @trip.points.build({ kind: 'To' })
    @required_points = [@point_from, @point_to]
    @optional_points = []
    3.times do |i|
      @optional_points << @trip.points.build({ kind: 'Step', rank: (i + 1) })
    end
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      redirect_to @trip, notice: 'Votre annonce est enregistrée mais pas encore publiée. Nous vous avons envoyé un mail de confirmation pour valider votre annonce.'
    else
      @required_points = [@trip.point_from, @trip.point_to]
      @optional_points = @trip.step_points
      render :new
    end
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
      params.require(:trip).permit(:date, :hour, :kind, :leave_at, :hour, :price, :description, :title, :name, :age, :phone, :email,
                                   points_attributes: [
                                       :id, :kind, :location_name, :location_coordinates, :_destroy
                                   ]
      )
    end

end