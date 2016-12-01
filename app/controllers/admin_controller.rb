class AdminController < ApplicationController

  before_action :authenticate_user!
  before_action :user_must_be_admin

  private

  def user_must_be_admin
    current_user.admin?
  end

end