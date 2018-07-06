class MessagesController < ApplicationController

  skip_before_action :verify_authenticity_token

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
      _message_params = [
        :sender_name, :sender_email, :sender_phone, :body, :trip_id
      ]
      if user_signed_in?
        params.require(:message).permit(*_message_params).merge(
          sender_name: current_user.display_name,
          sender_email: current_user.email,
          sender_phone: current_user.telephone || '-'
        )
      else
        params.require(:message).permit(*_message_params)
      end
    end

end
