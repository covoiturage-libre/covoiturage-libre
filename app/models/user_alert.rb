class UserAlert < ApplicationRecord
  DEFAULT_SEARCH_AROUND_DISTANCE_IN_METERS = 25_000
  MAX_SEARCH_AROUND_DISTANCE_IN_METERS = 50_000

  belongs_to :user

  validates_presence_of :departure_from_date, :departure_from_time, :departure_to_date, :departure_to_time

  validate :must_departure_dates_be_interval

  scope :from_and_to_null, -> { from_null.to_null }
  scope :from_null, -> { where('from_lat IS NULL AND from_lon IS NULL') }
  scope :from_point, -> (point, around_distance) { where("ST_Dwithin(
      ST_GeographyFromText('SRID=4326;POINT(' || from_lon || ' ' || from_lat || ')'),
      ST_GeographyFromText('SRID=4326;POINT(? ?)'),
      #{around_distance}
    )", point.lon.to_f, point.lat.to_f)
  }
  scope :to_null, -> { where('to_lat IS NULL AND to_lon IS NULL') }
  scope :to_point, -> (point, around_distance) { where("ST_Dwithin(
      ST_GeographyFromText('SRID=4326;POINT(' || to_lon || ' ' || to_lat || ')'),
      ST_GeographyFromText('SRID=4326;POINT(? ?)'),
      #{around_distance}
    )", point.lon.to_f, point.lat.to_f)
  }

  def self.find_by_trip(trip, around_distance = DEFAULT_SEARCH_AROUND_DISTANCE_IN_METERS)
    around_distance = [
      around_distance || DEFAULT_SEARCH_AROUND_DISTANCE_IN_METERS,
      MAX_SEARCH_AROUND_DISTANCE_IN_METERS
    ].min

    # No departure / destination specified
    user_alerts = self.from_and_to_null

    points = trip.points.order(:rank)

    points.each_with_index do |p1, i|
      points[i+1..-1].each do |p2, j|
        user_alerts = user_alerts.or(
          UserAlert.from_point(p1, around_distance).to_null.where('max_price >= ?', (p2.price || 0)-(p1.price || 0))
        ).or(
          UserAlert.from_null.to_point(p2, around_distance).where('max_price >= ?', (p2.price || 0)-(p1.price || 0))
        ).or(
          UserAlert.from_point(p1, around_distance).to_point(p2, around_distance).where('max_price >= ?', (p2.price || 0)-(p1.price || 0))
        )
      end
    end

    user_alerts = user_alerts.where('departure_from_date <= ? OR departure_from_date IS NULL', trip.departure_date)
    user_alerts = user_alerts.where('departure_to_date >= ? OR departure_to_date IS NULL', trip.departure_date)
    user_alerts = user_alerts.where('departure_from_time <= ?', trip.departure_time)
    user_alerts = user_alerts.where('departure_to_time >= ?', trip.departure_time)
    user_alerts = user_alerts.where('smoking = ? OR smoking IS NULL', trip.smoking)
    #user_alerts = user_alerts.where('max_price >= ?', trip.price)
    user_alerts = user_alerts.where('min_seats <= ?', trip.seats)
    comfort_index = Trip::CAR_RATINGS.index(trip.comfort)
    comforts = Trip::CAR_RATINGS[0..comfort_index]
    user_alerts = user_alerts.where(min_comfort: comforts)
  end

  private

    def must_departure_dates_be_interval
      return if departure_from_date.nil? || departure_to_date.nil?
      if departure_from_date > departure_to_date
        errors.add(:departure_to_date, "L'intervalle de date est incorrecte")
      end
    end
end
