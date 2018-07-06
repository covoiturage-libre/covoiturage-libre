class ChangeTripsPriceDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :trips, :price, :integer, null: false, default: 0
  end
end
