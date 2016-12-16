class TripsController < ApplicationController
  include ApplicationHelper

  def show
    @trip = Trip.find_by_confirmation_token(params[:id])
    unless @trip.confirmed?
      render :not_found
      return
    end
  end

  def index
    params.permit!
    @trips = Trip.all.order(created_at: :desc).page(params[:page]).per(5)
  end

  def new
    @trip = Trip.new(departure_time: Time.parse('12:00'))
    build_points
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      # do nothing, render create page
    else
      build_points
      render :new
    end
  end

  # caution, this is a modifying action reached by a GET method
  def confirm
    @trip = Trip.find_by(confirmation_token: params[:id])
    if @trip
      if @trip.confirm!
        # do nothing, render confirm page
      else
        render :not_found # let's give no information on this error to the internet
      end
    else
      render :not_found # let's give no information on this error to the internet
    end
  end

  def edit
    @trip = Trip.find_by(edition_token: params[:id])
    if @trip
      build_points
    else
      render :not_found # let's give no information on this error to the internet
    end
  end

  def update
    @trip = Trip.find_by_confirmation_token(params[:id])
    if @trip.update_attributes(trip_params)
      # do nothing, render update page
    else
      build_points
    end
  end

  # caution, this is a destructive action reached by a GET method
  def delete
    @trip = Trip.find_by(deletion_token: params[:id])
    if @trip
      if @trip.soft_delete!
        # do nothing, render update page
      else
        render :not_found # let's give no information on this error to the internet
      end
    else
      render :not_found # let's give no information on this error to the internet
    end
  end

  def resend_email
    @trip = Trip.find_by_confirmation_token(params[:id])
    if @trip
      @trip.send_information_email
      redirect_to @trip, notice: "Nous vous avons renvoyé le mail de validation de l'annonce."
    else
      render :not_found # let's give no information on this error to the internet
    end
  end

  def new_from_copy
    @trip = Trip.find_by_edition_token(params[:id])
    if @trip
      @trip = @trip.clone_without_date
      build_points
      render :new
    else
      render :not_found # let's give no information on this error to the internet
    end
  end

  def new_for_back
    @trip = Trip.find_by_edition_token(params[:id])
    if @trip
      @trip = @trip.clone_as_back_trip
      build_points
      render :new
    else
      render :not_found # let's give no information on this error to the internet
    end
  end

  # Ajax only methods

  def points
    @trip = Trip.find_by_confirmation_token(params[:id])
    render json: @trip.points
  end

  private

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
                                   :terms_of_service,
                                   :total_distance,
                                   :total_time,
                                   points_attributes: [
                                       :id, :kind, :rank, :city, :lon, :lat, :price, :_destroy
                                   ]
      )
    end

    def build_points
      return nil if @trip.nil?
      point_from = @trip.point_from || @trip.points.build({ kind: 'From', rank: 0 })
      point_to = @trip.point_to || @trip.points.build({ kind: 'To', rank: 99 })
      @required_points = [point_from, point_to]
      @optional_points = @trip.step_points.empty? ? build_three_step_points : @trip.step_points
    end

    def build_three_step_points
      return nil if @trip.nil?
      three_step_points = []
      # user this to build n points on a new record
      0.times do |i|
        three_step_points << @trip.points.build({ kind: 'Step', rank: (i + 1) })
      end
      three_step_points
    end

end
