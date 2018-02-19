class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string :name, limit: 50, index: true
      t.string :postal_code, limit: 10
      t.string :department, limit: 2
      t.string :region, limit: 10
      t.string :country_code, limit: 2
      t.decimal :lat, precision: 9, scale: 6
      t.decimal :lon, precision: 9, scale: 6
      t.decimal :distance, precision: 4, scale: 2

      t.timestamps
    end
  end
end
