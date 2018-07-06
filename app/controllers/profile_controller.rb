class ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  respond_to :html

  # GET /profile
  # GET /profile.json
  def show
  end

  # GET /profile/edit
  def edit
  end

  # PATCH/PUT /profile
  # PATCH/PUT /profile.json
  def update
    @user.email = user_params[:email]
    email_changed = @user.email_changed?
    respond_to do |format|
      if @user.update(user_params)
        notice = "Votre profil a correctement été mis à jour."
        if email_changed
          notice += " Un mail de confirmation d'adresse mail a été envoyé à #{user_params[:email]}."
        end
        format.html { redirect_to profile_path, notice: notice }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /profile/trips
  def trips
    @incoming_trips = current_user.trips.undeleted.unrepeated.incoming.soon
    @repeated_trips = current_user.trips.undeleted.repeated.latests
    @deleted_trips = current_user.trips.deleted.latests
    @past_trips = current_user.trips.past.desc
  end

  def alerts
    @user_alerts = current_user.user_alerts
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to profile_path, notice: 'Un email vous a été envoyé. Veuillez cliquer sur le lien fourni pour confirmer votre adresse email.'
      else
        @show_errors = true
      end
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    _user_params = [
      :email, :remember_me, :display_name, :date_of_birth, :telephone,
    ]
    if params[:user][:password] != "" and params[:user][:password_confirmation] != ""
      _user_params.concat([:password, :password_confirmation])
    end
    params.require(:user).permit(*_user_params)
  end
end
