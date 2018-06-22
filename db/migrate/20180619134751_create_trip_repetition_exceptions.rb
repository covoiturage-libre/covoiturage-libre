class CreateTripRepetitionExceptions < ActiveRecord::Migration[5.1]
  def change
    create_table :trip_repetition_exceptions do |t|
      t.references :trip, foreign_key: true
      t.date :exception_date

      t.timestamps
    end
  end
end
