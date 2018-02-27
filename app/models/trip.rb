# coding: utf-8
class Trip < ApplicationRecord

  # use of this classification https://en.wikipedia.org/wiki/Hotel_rating
  CAR_RATINGS = %w(standard comfort first_class luxury).freeze
  STATES = %w(pending confirmed deleted).freeze

  # maximum nb of steps = max rank - 1
  STEPS_MAX_RANK = 16

  SEARCH_DISTANCE_IN_METERS = 25_000

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
  validate :must_have_different_points

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

  scope :from_to, -> (from_lon, from_lat, to_lon, to_lat) {
    # Avoid Trips doublon
    matching_points = Point.select("DISTINCT ON (point_a.trip_id) point_a.*,
      point_a.id as point_a_id, point_a.price as point_a_price,
      point_b.id as point_b_id, point_b.price as point_b_price,

      (ST_Distance(
        ST_GeographyFromText('SRID=4326;POINT(' || point_a.lon || ' ' || point_a.lat || ')'),
        ST_GeographyFromText('SRID=4326;POINT(#{from_lon.to_f} #{from_lat.to_f})')
      ) + ST_Distance(
        ST_GeographyFromText('SRID=4326;POINT(' || point_b.lon || ' ' || point_b.lat || ')'),
        ST_GeographyFromText('SRID=4326;POINT(#{to_lon.to_f} #{to_lat.to_f})')
      )) AS point_ab_distance").
    from('points AS point_a').
    joins('INNER JOIN points AS point_b ON point_b.trip_id = point_a.trip_id').
    where("ST_Dwithin(
           ST_GeographyFromText('SRID=4326;POINT(' || point_a.lon || ' ' || point_a.lat || ')'),
           ST_GeographyFromText('SRID=4326;POINT(? ?)'),
           #{SEARCH_DISTANCE_IN_METERS})", from_lon.to_f, from_lat.to_f).
    where("ST_Dwithin(
           ST_GeographyFromText('SRID=4326;POINT(' || point_b.lon || ' ' || point_b.lat || ')'),
           ST_GeographyFromText('SRID=4326;POINT(? ?)'),
           #{SEARCH_DISTANCE_IN_METERS})", to_lon.to_f, to_lat.to_f).
    where('point_a.rank < point_b.rank').
    order('point_a.trip_id ASC, point_ab_distance ASC')

    select('trips.*,
      point_a_id, point_a_price,
      point_b_id, point_b_price,
      trips.id'). # trips.id is necessary here for the COUNT_COLUMN method used by Kaminari counting.
    joins("INNER JOIN (#{matching_points.to_sql}) AS point_a ON trips.id = point_a.trip_id")
  }

  scope :from_only, -> (from_lon, from_lat) {
    # Avoid Trips doublon
    matching_points = Point.select("DISTINCT ON (point_a.trip_id) point_a.*,
      point_a.id AS point_a_id, point_a.price AS point_a_price,
      ST_Distance(
        ST_GeographyFromText('SRID=4326;POINT(' || point_a.lon || ' ' || point_a.lat || ')'),
        ST_GeographyFromText('SRID=4326;POINT(#{from_lon.to_f} #{from_lat.to_f})')
      ) AS point_a_distance")
    .from('points AS point_a')
    .where("ST_Dwithin(
      ST_GeographyFromText('SRID=4326;POINT(' || point_a.lon || ' ' || point_a.lat || ')'),
      ST_GeographyFromText('SRID=4326;POINT(? ?)'),
      #{SEARCH_DISTANCE_IN_METERS}
    )", from_lon.to_f, from_lat.to_f)
    .where("point_a.kind <> 'To'")
    .order('point_a.trip_id ASC, point_a_distance ASC')

    select('trips.*,
      point_a_id, point_a_price, point_a_distance,
      trips.id'). # trips.id is necessary here for the COUNT_COLUMN method used by Kaminari counting.
    joins("INNER JOIN (#{matching_points.to_sql}) AS point_a ON trips.id = point_a.trip_id")
  }

  scope :to_only, -> (to_lon, to_lat) {
    # Avoid Trips doublon
    matching_points = Point.select("DISTINCT ON (point_b.trip_id) point_b.*,
      point_b.id AS point_b_id, point_b.price AS point_b_price,
      ST_Distance(
        ST_GeographyFromText('SRID=4326;POINT(' || point_b.lon || ' ' || point_b.lat || ')'),
        ST_GeographyFromText('SRID=4326;POINT(#{to_lon.to_f} #{to_lat.to_f})')
      ) AS point_b_distance")
    .from('points AS point_b')
    .where("ST_Dwithin(
      ST_GeographyFromText('SRID=4326;POINT(' || point_b.lon || ' ' || point_b.lat || ')'),
      ST_GeographyFromText('SRID=4326;POINT(? ?)'),
      #{SEARCH_DISTANCE_IN_METERS}
    )", to_lon.to_f, to_lat.to_f)
    .where("point_b.kind <> 'From'")
    .order('point_b.trip_id ASC, point_b_distance ASC')

    select('trips.*,
      point_b_id, point_b_price, point_b_distance,
      trips.id'). # trips.id is necessary here for the COUNT_COLUMN method used by Kaminari counting.
    joins("INNER JOIN (#{matching_points.to_sql}) AS point_b ON trips.id = point_b.trip_id")
  }

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
      if points.empty? || point_from.nil? || point_to.nil?
        errors.add(:base, "Le départ et l'arrivée du voyage sont nécessaires.")
      end
    end

    def must_have_different_points
      if points.size > 1 &&
        (points.uniq(&:city).size < points.size ||
          points.uniq { |p| [p.lat, p.lng] }.size < points.size)
        errors.add(:points, "Des points ou étapes sont identiques.")
      end
    end

    def set_last_point_price
      self.point_to.update_attribute(:price, self.price)
    end

end
