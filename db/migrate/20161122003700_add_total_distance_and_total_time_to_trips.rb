class AddTotalDistanceAndTotalTimeToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :total_distance, :float
    add_column :trips, :total_time, :float
  end
end
