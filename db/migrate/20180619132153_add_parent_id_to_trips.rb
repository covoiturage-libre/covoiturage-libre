class AddParentIdToTrips < ActiveRecord::Migration[5.1]
  def change
    add_reference :trips, :parent, index: true
    add_column :trips, :repeat, :boolean, null: false, default: false
    add_column :trips, :repeat_week, :integer, null: false, default: 1
    add_column :trips, :repeat_started_at, :date
    add_column :trips, :repeat_ended_at, :date
  end
end
