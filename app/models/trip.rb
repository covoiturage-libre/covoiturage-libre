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

  has_many :trip_repetitions, dependent: :destroy
  has_many :trip_repetition_exceptions, dependent: :destroy
  has_many :children, class_name: "Trip", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Trip"

  belongs_to :user

  has_secure_token :confirmation_token
  has_secure_token :edition_token
  has_secure_token :deletion_token

  accepts_nested_attributes_for :points, allow_destroy: true, reject_if: proc {|attrs| attrs[:city].blank? && attrs[:kind]=='Step' }
  accepts_nested_attributes_for :trip_repetitions, allow_destroy: true
  accepts_nested_attributes_for :trip_repetition_exceptions, allow_destroy: true
  accepts_nested_attributes_for :children, allow_destroy: true

  validates_presence_of :seats, :comfort, :state
  validates_presence_of :departure_date, :departure_time, unless: -> (trip) { trip.repeat }
  validates_presence_of :repeat_started_at, :repeat_ended_at, if: -> (trip) { trip.repeat }
  validates_presence_of :price if Rails.configuration.pricing
  validates_presence_of :title, :name, :email, unless: -> (trip) { trip.user_id.present? }
  validates_inclusion_of :smoking, in: [true, false]
  validates_inclusion_of :comfort, in: CAR_RATINGS
  validates_inclusion_of :state, in: STATES
  validates_inclusion_of :departure_date, in: Time.zone.today..Time.zone.today+1.year, message: "Mettre une date située entre aujourd'hui et dans 1 an.", unless: -> (trip) { trip.repeat }
  validates_inclusion_of :repeat_started_at, :repeat_ended_at, in: Time.zone.today..Time.zone.today+1.year, message: "Mettre une date située entre aujourd'hui et dans 1 an.", if: -> (trip) { trip.repeat }
  validates_numericality_of :seats, only_integer: true, greater_than_or_equal_to: 0
  validates_numericality_of :price, only_integer: true, greater_than_or_equal_to: 0  if Rails.configuration.pricing
  validates_numericality_of :age, only_integer: true, allow_blank: true, greater_than: 0, less_than: 100, unless: -> (trip) { trip.user_id.present? }

  validate :must_have_from_and_to_points
  validates_acceptance_of :terms_of_service
  validates :email, email: true, unless: -> (trip) { trip.user_id.present? }
  validates_with PricesValidator if Rails.configuration.pricing
  validate :must_have_different_points
  validate :must_repeat_dates_be_interval, if: -> (trip) { trip.repeat }

  before_validation :strip_whitespace
  before_save :build_children

  after_create :send_confirmation_email, unless: -> (trip) { trip.parent.present? }
  after_save :set_last_point_price

  # eager load points each time a trip is requested
  default_scope { includes(:points) }

  scope :published, -> { where(state: 'confirmed') }
  scope :unrepeated, -> { where(repeat: false) }
  scope :repeated, -> { where(repeat: true) }
  scope :for_today, -> { published.where(['departure_date = ? AND departure_time > ?', Date.today, Time.now]) }
  scope :latests, -> { published.where('departure_date >= ?', Date.today).order(created_at: :desc) }
  scope :incoming, -> { published.where('departure_date > ?', Date.today).or(for_today).order(departure_date: :asc, departure_time: :asc) }

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
    self.children.update_all(state: 'confirmed')
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
    new_trip.points = self.points.map(&:dup)

    new_trip
  end

  def clone_as_back_trip
    new_trip = self.dup
    # new_trip.departure_date = new_trip.departure_time = nil

    # reverse ranks, kinds and adjust prices
    new_trip.points = self.points.reverse.each_with_index.map do |point, new_index|
      new_point = point.dup
      new_point.rank = new_index
      new_point.price = point.price ? (self.price - point.price) : nil

      new_point
    end
    new_trip.points.first.kind = 'From'
    new_trip.points.last.kind = 'To'

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
      if points.empty? || point_from.nil? || point_to.nil?
        errors.add(:base, "Le départ et l'arrivée du voyage sont nécessaires.")
      end
    end

    def must_have_different_points
      if points.size > 1 &&
        (points.to_a.uniq(&:city).size < points.size ||
          points.to_a.uniq { |p| [p.lat, p.lon] }.size < points.size)
        errors.add(:points, "Des points ou étapes sont identiques.")
      end
    end

    def set_last_point_price
      self.point_to.update_attribute(:price, self.price)
    end

    def must_repeat_dates_be_interval
      return if repeat_started_at.nil? || repeat_ended_at.nil?
      if repeat_started_at > repeat_ended_at
        errors.add(:repeat_ended_at, "L'intervalle de date est incorrecte")
      end
    end

    def strip_whitespace
      self.email = strip_value(self.email)
      self.name = strip_value(self.name)
      self.phone = strip_value(self.phone)
      self.description = strip_value(self.description)
    end

    def build_children
      week = 0
      if repeat && (
        trip_repetitions.any?(&:changed?) ||
        trip_repetition_exceptions.any?(&:changed?) ||
        points.any?(&:changed?) ||
        seats_changed? ||
        comfort_changed? ||
        price_changed? ||
        smoking_changed? ||
        title_changed? ||
        name_changed? ||
        email_changed? ||
        phone_changed? ||
        description_changed? ||
        repeat_started_at_changed? ||
        repeat_ended_at_changed? ||
        repeat_week_changed?
      )

        self.children = Trip.none
        repeat_started_at.upto(repeat_ended_at) do |date|
          day = date.strftime('%A').downcase
          if week % repeat_week == 0
            trip_repetitions.select {|tr| tr.day_of_week == day}.each do |tr|
              self.children.build(
                departure_date: date,
                departure_time: tr.departure_time,
                seats: seats,
                comfort: comfort,
                description: description,
                price: price,
                title: title,
                smoking: smoking,
                name: name,
                age: age,
                email: email,
                phone: phone,
                user: user,
                state: state,
                points_attributes: self.points.sort_by {|point| tr.backway ? -point.rank : point.rank }.each_with_index.map { |point, index|
                  point.dup.attributes.merge(
                    rank: index,
                    kind: index == 0 ? "From" : index == self.points.length-1 ? "To" : "Step",
                    price: !tr.backway ? point.price : self.price.present? && point.price.present? ? (self.price - point.price) : nil
                  )
                }
              )
            end
          end
          week += 1 if day == 'sunday'
        end
      end
    end

end
