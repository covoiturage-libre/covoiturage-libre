class TripsController < ApplicationController

  def show
    @trip = Trip.find_by_confirmation_token(params[:id])
    unless @trip.confirmed?
      flash[:notice] = 'Votre annonce est enregistrée mais pas encore publiée. Nous vous avons envoyé un mail de confirmation pour valider votre annonce.'
    end
  end

  def index
    params.permit!
    @trips = Trip.all.order(created_at: :desc).page(params[:page]).per(5)
  end

  def new
    @trip = Trip.new
    build_points
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      redirect_to @trip, notice: 'Votre annonce est enregistrée mais pas encore publiée. Nous vous avons envoyé un mail de confirmation pour valider votre annonce.'
    else
      build_points
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
      build_points
      render :edit
    else
      render :not_found # let's give no information on this error to the internet
    end
  end

  def update
    @trip = Trip.find_by_confirmation_token(params[:id])
    if @trip.update_attributes(trip_params)
      redirect_to @trip, notice: 'Votre annonce est mise à jour. Merci pour votre contribution à la communauté!'
    else
      build_points
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

  def points
    @trip = Trip.find_by_confirmation_token(params[:id])
    render json: @trip.points
  end

  def resend_email
    @trip = Trip.find_by_confirmation_token(params[:id])
    if @trip
      @trip.send_information_email
      redirect_to @trip, notice: "Nous vous avons renvoyé le mail de gestion de l'annonce à l´annonce."
    else
      render :not_found # let's give no information on this error to the internet
    end
  end

  def new_from_copy
    @trip = Trip.find_by_confirmation_token(params[:id])
    if @trip
      @trip = @trip.clone_without_date
      build_points
      render :new
    else
      render :not_found # let's give no information on this error to the internet
    end
  end

  def new_for_back
    @trip = Trip.find_by_confirmation_token(params[:id])
    if @trip
      @trip = @trip.clone_as_back_trip
      build_points
      render :new
    else
      render :not_found # let's give no information on this error to the internet
    end
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
      0.times do |i|
        three_step_points << @trip.points.build({ kind: 'Step', rank: (i + 1) })
      end
      three_step_points
    end

end
