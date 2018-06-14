class Ability
  include CanCan::Ability

  def self.actions
    [:manage, :index, :read, :create, :update, :delete, :lock, :publish, :authorize]
  end

  def initialize(user)
    user ||= User.new(role: :guest) # guest user (not logged in)

    can :edit, user

    user.all_permissions.each do |permission|
      if permission.targetable_type.nil? or permission.targetable_type.blank?
        can permission.action.to_sym, :all
      elsif permission.targetable_id.nil?
        can permission.action.to_sym, permission.targetable_type.constantize
      else
        can permission.action.to_sym, permission.targetable_type.constantize, id: permission.targetable_id
      end
    end
  end
end
