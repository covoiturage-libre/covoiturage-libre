class CreateUserAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :user_alerts do |t|
      t.references :user, foreign_key: true
      t.date :departure_from_date
      t.time :departure_from_time
      t.date :departure_to_date
      t.time :departure_to_time
      t.boolean :smoking
      t.float :max_price
      t.integer :min_seats
      t.string :min_comfort
      t.decimal :from_lat, precision: 9, scale: 6
      t.decimal :from_lon, precision: 9, scale: 6
      t.string :from_city
      t.decimal :to_lat, precision: 9, scale: 6
      t.decimal :to_lon, precision: 9, scale: 6
      t.string :to_city

      t.timestamps
    end
  end
end
