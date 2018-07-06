class AddTripsOnUserDelete < ActiveRecord::Migration[5.1]
  def change
    remove_reference :trips, :user
    add_reference :trips, :user, foreign_key: { on_delete: :nullify }
  end
end
