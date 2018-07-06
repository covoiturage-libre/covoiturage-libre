class User < ApplicationRecord
  include Omniauthable

  ROLES = %w(admin).freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :trips
  has_many :user_alerts

  validates_inclusion_of :role, in: ROLES, allow_blank: true
  validates_presence_of :display_name, :email

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login)).present?
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:reset_password_token)
      where(reset_password_token: conditions[:reset_password_token]).first
    else
      unless conditions.is_a? ActiveSupport::HashWithIndifferentAccess or conditions.is_a? Hash
        conditions.permit!
      end
      where(conditions).first
    end
  end

  def admin?
    role == 'admin'
  end

  def age
    now = Time.now.utc.to_date
    dob = date_of_birth
    if dob.present?
      "#{now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)} ans"
    else
      nil
    end
  end

end
