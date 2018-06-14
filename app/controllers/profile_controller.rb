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
    _opening_hours_params = [:id, :day, :opened, :from, :to, :splitted, :from2, :to2]
    _brands_params = [:id, :name, :_destroy]
    _city_params = [:id, :name]
    _repairer_params = [ :id,
      :company_name, :company_type, :company_type_id, :address, :zip_code, :telephone, :fax, :website, :facebook_url, :category,
      :category_id, :company_description, :service_description, :seniority, :opens_at, :closes_at, :open_sat_at, :close_sat_at,
      :intervention_area, :region, :department, :rate_description, :travel_expenses, :emergency_service,  :emergency_service_description,
      :payment_by_check, :payment_by_credit_card, :payment_by_cash, :payment_by_other_method, :free_estimate, :estimate_description,
      :warranty_period_id, :warranty_description, :b_to_b, :b_to_c, :intervention_delay_id, :device_recycling, :recycling_description,
      :spare_parts, :spare_parts_description, :equipment_loan, :equipment_loan_description, :remote_troubleshooting,
      :remote_troubleshooting_description, :home_troubleshooting, :home_troubleshooting_description, :approved_brands,
      :approved_brands_free_troubleshooting, :siret, :premium_interested, :opening_hours_description, :payment_by_method, :payment_by_check_cesu,
      opening_hours_attributes: _opening_hours_params,
      brands_attributes: _brands_params,
      city_attributes: _city_params,
      category_ids: []
    ]
    _user_params = [
      :username, :email, :remember_me, :firstname, :lastname, :avatar, :gender, :date_of_birth, :newsletter, :how_you_know_us,
      repairer_attributes: _repairer_params
    ]
    if params[:user][:password] != "" and params[:user][:password_confirmation] != ""
      _user_params.concat([:password, :password_confirmation])
    end
    params.require(:user).permit(*_user_params)
  end
end
