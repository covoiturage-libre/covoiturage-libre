class Admin::UsersController < AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :lock, :unlock, :send_reset_password_mail, :send_confirmation_mail]

  # GET /admin/users
  # GET /admin/users.json
  # GET /admin/users.csv
  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @users.to_json }
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
  end

  # GET /admin/users/new
  def new
    @user = User.new(role: params[:role])
    @user = @user.with_repairer if params[:role] == 'repairer'
  end

  # GET /admin/users/1/edit
  def edit
    role = "admin" if @user.role? 'superadmin'
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    @user = User.new(user_params)
    @user = @user.with_repairer if params[:role] == 'repairer'
    @user.repairer.draft = false if publishing?
    respond_to do |format|
      if @user.save
        if user_params[:repairer_attributes].present? and user_params[:repairer_attributes][:images].respond_to?('each')
          user_params[:repairer_attributes][:images].each do |image|      
            @user.repairer.repairer_images.create(image: image, alt: image.original_filename)
          end
        end
        format.html { redirect_to [:admin, @user], notice: "L'utilisateur a correctement été créé" }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/users/1
  # PATCH/PUT /admin/users/1.json
  def update
    @user.repairer.draft = false if publishing?
    @user.repairer.draft = true if unpublishing?
    email_changed = @user.email_changed?
    respond_to do |format|
      if @user.update(user_params)
        if user_params[:repairer_attributes].present? and user_params[:repairer_attributes][:images].respond_to?('each')
          user_params[:repairer_attributes][:images].each do |image|      
            @user.repairer.repairer_images.create(image: image, alt: image.original_filename)
          end
        end
        if email_changed
          flash[:notice] = "Un mail de confirmation d'adresse mail a été envoyé à #{user_params[:email]}"
        end
        if newpassword?
          @user.send_reset_password_instructions
          flash[:notice] = "Un mail de réinitialisation de mot de passe a été envoyé à #{@user.email}"
        end
        format.html { redirect_to [:admin, @user, tab: params[:tab]], notice: "L'utilisateur a correctement été mis à jour" }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url }
      format.json { head :no_content }
    end
  end

  # PUT /admin/users/1/lock
  # PUT /admin/users/1/lock.json
  def lock
    @user.ban
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { head :no_content }
    end
  end

  # DELETE /admin/users/1/lock
  # DELETE /admin/users/1/lock.json
  def unlock
    @user.unlock
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { head :no_content }
    end
  end


  def send_reset_password_mail
    @user.send_reset_password_instructions
    flash[:notice] = "Un mail de réinitialisation de mot de passe a été envoyé à #{@user.email}"
    redirect_to :back
  end

  def send_confirmation_mail
    @user.send_confirmation_instructions
    flash[:notice] = "Un mail de confirmation a été envoyé à #{@user.email}"
    redirect_to :back
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id] || params[:user_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    _cv_positions_params = [:id, :title, :row_order_position, :_destroy]
    _cv_skills_params = [:id, :name, :value, :row_order_position, :_destroy]
    _cv_links_params = [:id, :url, :row_order_position, :_destroy]
    _cv_params = [
      :id, :content, :short_description, :user_id,
      cv_positions_attributes: _cv_positions_params,
      cv_skills_attributes: _cv_skills_params,
      cv_links_attributes: _cv_links_params
    ]
    _permissions_params = [
      :id, :can, :action, :targetable_type, :targetable_id, :_destroy,
    ]
    _user_params = [
      :username, :email, :remember_me, :firstname, :lastname, :avatar, :gender, :date_of_birth, :newsletter, :how_you_know_us,
      role_ids: [],
      cv_attributes: _cv_params,
      permissions_attributes: _permissions_params
    ]
    if params[:user][:password] != "" and params[:user][:password_confirmation] != ""
      _user_params.concat([:password, :password_confirmation])
    end
    params.require(:user).permit(*_user_params)
  end

 def publishing?
   params[:commit].include? "publier"
 end

 def unpublishing?
   params[:commit].include? "dépublier"
 end

 def newpassword?
   params[:commit].include? @user.email
 end
end
