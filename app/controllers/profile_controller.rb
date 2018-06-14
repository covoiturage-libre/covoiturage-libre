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
    @user.update(user_params)
    respond_with(@user, location: profile_path)
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
      :email, :remember_me, :display_name
    ]
    if params[:user][:password] != "" and params[:user][:password_confirmation] != ""
      _user_params.concat([:password, :password_confirmation])
    end
    params.require(:user).permit(*_user_params)
  end
end
