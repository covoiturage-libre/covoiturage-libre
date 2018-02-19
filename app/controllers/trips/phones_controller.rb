class Trips::PhonesController < ApplicationController

  def show
    @trip = Trip.find_by(confirmation_token: params[:trip_id])
  end

end