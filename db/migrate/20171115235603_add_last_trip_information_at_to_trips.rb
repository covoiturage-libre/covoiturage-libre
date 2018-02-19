class AddLastTripInformationAtToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :last_trip_information_at, :datetime
  end
end
