class MessagesController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def create
    @trip = Trip.find_by_confirmation_token(params[:trip_id])
    @message = @trip.messages.new(message_params)
    if @message.save
      respond_to do |format|
        format.js { render :create }
      end
    else
      respond_to do |format|
        format.js { render :errors }
      end
    end
  end

  private

    def message_params
      params.require(:message).permit(:sender_name, :sender_email, :sender_phone, :body, :trip_id)
    end

end