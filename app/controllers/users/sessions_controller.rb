# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include Devise::Controllers::Rememberable

  def new
    Devise.omniauth_configs.each do |provider, config|
      if config.strategy.redirect_at_sign_in
        return redirect_to(omniauth_authorize_path(resource_name, provider))
      end
    end
    super
  end

  def create
    super do |resource|
      remember_me(resource)
      flash.delete(:notice)
    end
  end

  def destroy
    super
    flash.delete(:notice)
  end

end
