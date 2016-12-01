class AdminController < ApplicationController

  before_action :authenticate_user!
  before_action :user_must_be_admin

  private

  def user_must_be_admin
    if !current_user.admin?
      redirect_to root_url, notice: 'Vous devez être administrateur.'
    end
  end

end