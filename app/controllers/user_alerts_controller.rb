class UserAlertsController < ApplicationController
  before_action :set_user_alert, only: [:show, :edit, :update, :destroy]

  def new
    @user_alert = current_user.user_alerts.build
  end

  def create
    @user_alert = current_user.user_alerts.build(user_alert_params)
    if @user_alert.save
      # do nothing, render create page
      redirect_to user_alert_path(@user_alert), notice: "Alerte créée. Vous receverez un email lorqu'une annonce correspondra à vos critères"
    else
      render :new
    end

    rescue ActiveRecord::MultiparameterAssignmentErrors
      @user_alert = user_alert.new(user_alert_params.except(*5.times.map { |i|
        "departure_time(#{i+1}i)"
      }))
      @user_alert.errors.add :departure_time, :invalid
      render :new
  end

  def show
  end

  def edit
  end


  def update
    if @user_alert.update_attributes(user_alert_params)
      redirect_to user_alert_path(@user_alert), notice: "Alerte modifiée. Vous receverez un email lorqu'une annonce correspondra à vos critères"
    else
      render :edit
    end
  end

  def destroy
  end

  private

  def set_user_alert
    @user_alert = UserAlert.find(params[:id] || params[:user_alert_id])
    redirect_to root_path, flash: { error: "Vous ne pouvez pas consulter cette alerte" } if @user_alert.user != current_user
  end

  def user_alert_params
    _user_alert_params = params.require(:user_alert).permit(:departure_from_date,
      :departure_from_time, :departure_to_date, :departure_to_time, :smoking,
      :max_price, :min_seats, :min_comfort,  :from_lat,  :from_lon, :from_city,
      :to_lat, :to_lon, :to_city)
    _user_alert_params[:smoking] = '' if _user_alert_params[:smoking] == 'on'
    _user_alert_params
  end
end
