class TripsController < ApplicationController

  before_filter :load_trip, only: [:show]

  def show
  end

  def index
  end

  def new
    flash[:notice] = "Bienvenue !!!"
    @trip = Trip.new
    point_from = @trip.points.build({ kind: 'From' })
    point_to = @trip.points.build({ kind: 'To' })
    @required_points = [point_from, point_to]
    @optional_points = build_three_step_points
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      redirect_to @trip, notice: 'Votre annonce est enregistrée mais pas encore publiée. Nous vous avons envoyé un mail de confirmation pour valider votre annonce.'
    else
      point_from = @trip.point_from || @trip.points.build({ kind: 'From' })
      point_to = @trip.point_to || @trip.points.build({ kind: 'To' })
      @required_points = [point_from, point_to]
      @optional_points = @trip.step_points.empty? ? build_three_step_points : @trip.step_points
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
      params.require(:trip).permit(:departure_date,
                                   :departure_time,
                                   :price,
                                   :description,
                                   :title,
                                   :name,
                                   :age,
                                   :phone,
                                   :email,
                                   :seats,
                                   :comfort,
                                   :smoking,
                                   points_attributes: [
                                       :id, :kind, :rank, :location_name, :location_coordinates, :_destroy
                                   ]
      )
    end

    def build_three_step_points
      three_step_points = []
      3.times do |i|
        three_step_points << @trip.points.build({ kind: 'Step', rank: (i + 1) })
      end
      three_step_points
    end

=begin
    def merge_leave_at_date_time_parameters(params)
      leave_at = Date
    end
=end

end