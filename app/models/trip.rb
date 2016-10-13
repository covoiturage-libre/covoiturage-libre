require 'elasticsearch/model'

class Trip < ApplicationRecord
  include Searchable

  # use of this classification https://en.wikipedia.org/wiki/Hotel_rating
  CAR_RATINGS = %w(standard comfort first_class luxury)
  STATES = %w(pending confirmed deleted)

  has_many :points, inverse_of: :trip, dependent: :destroy
  has_many :messages

  has_secure_token :confirmation_token
  has_secure_token :edition_token
  has_secure_token :deletion_token

  accepts_nested_attributes_for :points, reject_if: proc {|attrs| attrs[:location_name].blank? && attrs[:kind]=='Step' }

  validates_presence_of :departure_date, :departure_time, :price, :description, :title, :name, :age, :phone, :email, :seats, :comfort, :state
  validates_inclusion_of :smoking, in: [true, false]
  validates_inclusion_of :comfort, in: CAR_RATINGS
  validates_inclusion_of :state, in: STATES
  validates_numericality_of :price, :age, :seats
  validate :must_have_from_and_to_points

  after_create :send_information_email

  # eager load points each time a trip is requested
  default_scope { includes(:points).order('created_at ASC') }

  # access the departure point that comes eager loaded with a trip
  def point_from
    points.find { |point| point.kind == 'From' }
  end

  # access the destination point that comes eager loaded with a trip
  def point_to
    points.find { |point| point.kind == 'To' }
  end

  # access the steps point that comes eager loaded with a trip
  def step_points
    points.select { |point| point.kind == 'Step' }
  end

  def confirm!
    self.update_attribute(:state, 'confirmed')
  end

  def soft_delete!
    self.update_attribute(:state, 'deleted')
  end

  def confirmed?
    state == 'confirmed'
  end

  private

    def must_have_from_and_to_points
      logger.info errors.full_messages
      if points.empty? or point_from.nil? or point_to.nil?
        errors.add(:base, "Le départ et l'arrivée du voyage sont nécessaires")
      end
    end

    def send_information_email
      UserMailer.trip_information(self).deliver_now
    end

end
