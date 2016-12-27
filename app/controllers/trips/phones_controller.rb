class Trips::PhonesController < ApplicationController

  def show
    @trip = Trip.find_by(confirmation_token: params[:trip_id])
    respond_to do |format|
      format.js
    end
  end

end