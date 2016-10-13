class TripsController < ApplicationController

  before_filter :load_trip, only: [:show, :update]

  def show
    unless @trip.confirmed?
      flash[:notice] = 'Votre annonce est enregistrée mais pas encore publiée. Nous vous avons envoyé un mail de confirmation pour valider votre annonce.'
    end
  end

  def index
  end

  def new
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

  # caution, this is a modifying action reached by a GET method
  def confirm
    @trip = Trip.find_by(confirmation_token: params[:token])
    if @trip
      if @trip.confirm!
        redirect_to @trip, notice: 'Votre annonce est publiée! Merci pour votre contribution à la communauté!'
      else
        render :not_found # let's give no information on this error to the internet
      end
    else
      render :not_found # let's give no information on this error to the internet
    end
  end

  def edit
    flash[:notice] = "Vous pouvez modifier votre annonce en mettant à jour le formulaire ci-dessous."
    @trip = Trip.find_by(edition_token: params[:token])
    if @trip
      render :edit
    else
      render :not_found # let's give no information on this error to the internet
    end
  end

  def update
    if @trip.save
      redirect_to @trip, notice: 'Votre annonce est mise à jour. Merci pour votre contribution à la communauté!'
    else
      point_from = @trip.point_from || @trip.points.build({ kind: 'From' })
      point_to = @trip.point_to || @trip.points.build({ kind: 'To' })
      @required_points = [point_from, point_to]
      @optional_points = @trip.step_points.empty? ? build_three_step_points : @trip.step_points
      render :new
    end
  end

  # caution, this is a destructive action reached by a GET method
  def delete
    @trip = Trip.find_by(deletion_token: params[:token])
    if @trip
      if @trip.soft_delete!
        render :show, notice: "Votre annonce est supprimée. Pour annuler cliquez ici: <a href='/trips/@trip.id/confirm?confirmation_token: #{@trip.confirmation_token}'>Annuler</a>"
      else
        render :not_found # let's give no information on this error to the internet
      end
    else
      render :not_found # let's give no information on this error to the internet
    end
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

end