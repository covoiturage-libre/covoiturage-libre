class User < ApplicationRecord

  ROLES = %w(admin).freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy

  validates_inclusion_of :role, in: ROLES, allow_blank: true

  def self.create_from_omniauth(params)
    attributes = {
      email: params['info']['email'],
      password: Devise.friendly_token
    }

    create(attributes)
  end

  def admin?
    role == 'admin'
  end

end
