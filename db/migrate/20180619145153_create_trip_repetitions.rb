class CreateTripRepetitions < ActiveRecord::Migration[5.1]
  def change
    create_table :trip_repetitions do |t|
      t.references :trip, foreign_key: true
      t.boolean :backway
      t.string :day_of_week
      t.time :departure_time

      t.timestamps
    end
  end
end
