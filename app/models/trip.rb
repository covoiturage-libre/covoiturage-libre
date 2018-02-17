# coding: utf-8
class Trip < ApplicationRecord
  include Trips::Search

  # use of this classification https://en.wikipedia.org/wiki/Hotel_rating
  CAR_RATINGS = %w(standard comfort first_class luxury).freeze
  STATES = %w(pending confirmed deleted).freeze

  STEPS_MAX_RANK = 16 # maximum nb of steps = max rank - 1
  SEARCH_DISTANCE_IN_METERS = 25_000

  attr_accessor :the_previous_trip__departure_date

  has_many :points, -> { order('rank asc') }, inverse_of: :trip, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_secure_token :confirmation_token
  has_secure_token :edition_token
  has_secure_token :deletion_token

  accepts_nested_attributes_for :points, allow_destroy: true, reject_if: proc {|attrs| attrs[:city].blank? && attrs[:kind]=='Step' }

  validates_presence_of :departure_date, :departure_time, :price, :title, :name, :email, :seats, :comfort, :state
  validates_inclusion_of :smoking, in: [true, false]
  validates_inclusion_of :comfort, in: CAR_RATINGS
  validates_inclusion_of :state, in: STATES
  validates_inclusion_of :departure_date, in: Time.zone.today..Time.zone.today+1.year, message: "Mettre une date située entre aujourd'hui et dans 1 an."
  validates_numericality_of :seats, only_integer: true, greater_than_or_equal_to: 0
  validates_numericality_of :price, only_integer: true, greater_than_or_equal_to: 0
  validates_numericality_of :age, only_integer: true, allow_blank: true, greater_than: 0, less_than: 100

  validate :must_have_from_and_to_points
  validates_acceptance_of :terms_of_service
  validates :email, email: true
  validates_with PricesValidator

  before_validation :strip_whitespace

  def strip_whitespace
    self.email = strip_value(self.email)
    self.name = strip_value(self.name)
    self.phone = strip_value(self.phone)
    self.description = strip_value(self.description)
  end

  after_create :send_confirmation_email
  after_save :set_last_point_price

  # eager load points each time a trip is requested
  default_scope { includes(:points).order('created_at ASC') }

  def to_param
    confirmation_token
  end

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
    self.send_information_email
  end

  def soft_delete!
    self.update_attribute(:state, 'deleted')
  end

  def confirmed?
    state == 'confirmed'
  end

  def deleted?
    state == 'deleted'
  end

  def send_confirmation_email
    UserMailer.trip_confirmation(self).deliver_later
  end

  def send_information_email
    UserMailer.trip_information(self).deliver_later
  end

  def clone_without_date
    new_trip = self.dup
    new_trip.departure_date = new_trip.departure_time = nil
    new_trip.points = self.points.map { |p| p.dup }
    new_trip
  end

  def clone_as_back_trip
    new_trip = self.dup
    new_trip.departure_date = new_trip.departure_time = nil
    new_trip.points = self.points.reverse.map { |p| p.dup }
    new_trip.points.first.kind = 'From'
    new_trip.points.last.kind = 'To'
    # reverse ranks
    new_trip.points.last.rank = new_trip.points.first.rank
    new_trip.points.first.rank = 0
    new_trip.step_points.each_with_index { |sp, index| sp.rank = index + 1 }

    new_trip
  end

  def before_actual_time
    self.departure_time.hour < Time.now.hour || (self.departure_time.hour == Time.now.hour && self.departure_time.min <= Time.now.min)
  end

  def is_before_today?
    self.departure_date == Date.today && self.before_actual_time
  end

  def is_strictly_before(the_date)
    self.departure_date < the_date
  end

  def is_strictly_after(the_date)
    self.departure_date > the_date
  end

  private

    def must_have_from_and_to_points
      if points.empty? or point_from.nil? or point_to.nil?
        errors.add(:base, "Le départ et l'arrivée du voyage sont nécessaires.")
      end
    end

    def set_last_point_price
      self.point_to.update_attribute(:price, self.price)
    end

end
