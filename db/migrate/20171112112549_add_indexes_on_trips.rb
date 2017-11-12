class AddIndexesOnTrips < ActiveRecord::Migration[5.0]
  def change
    commit_db_transaction

    add_index :trips, :state, algorithm: :concurrently
    add_index :trips, :departure_date, algorithm: :concurrently
    add_index :trips, :departure_time, algorithm: :concurrently

    add_index :trips, :confirmation_token, algorithm: :concurrently
    add_index :trips, :edition_token, algorithm: :concurrently

    add_index :trips, :created_at, algorithm: :concurrently

    add_index :points, :kind, algorithm: :concurrently
    add_index :points, :rank, algorithm: :concurrently
  end
end
