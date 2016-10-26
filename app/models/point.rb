class Point < ApplicationRecord

  KINDS = %w( From Step To ).freeze

  belongs_to :trip, inverse_of: :points

  attr_accessor :location_name, :location_coordinates

  validates_presence_of :location_name, :location_coordinates
  validates_presence_of :kind, :rank, :trip, :lat, :lon, :city
  validates_inclusion_of :kind, in: KINDS
  validates_numericality_of :rank

  before_validation :set_lat_lon, :set_city, :set_from_rank, :set_to_rank

  def as_json(options={})
    super(
        only: [:kind, :rank, :city]
    ).merge(location: {
        lat: lat.to_f, lon: lon.to_f
    })
  end

  private

    def set_lat_lon
      loc_coord_arr = location_coordinates.split(',')
      if loc_coord_arr.count == 2
        self.lat = loc_coord_arr.first
        self.lon = loc_coord_arr.last
      else
        errors.add(:base, 'Les coordonnées GPS sont nécessaires')
      end
    end

    def set_city
      self.city = location_name
    end

    def set_from_rank
      self.rank = 0 if self.kind == 'From'
    end

    def set_to_rank
      self.rank = 99 if self.kind == 'To'
    end

end
