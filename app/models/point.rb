class Point < ApplicationRecord

  belongs_to :trip, optional: true

  attr_accessor :location_name, :location_coordinates

  validates_presence_of :lat, :lon, :city

  before_validation :set_lat_lon, :set_city

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

end
