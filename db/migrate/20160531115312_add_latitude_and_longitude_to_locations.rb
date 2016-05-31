class AddLatitudeAndLongitudeToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :latitude, :decimal, precision: 9, scale: 6
    add_column :locations, :longitude, :decimal, precision: 9, scale: 6
  end
end
