class AddCodeInseeToCities < ActiveRecord::Migration[5.1]
  def change
    add_column :cities, :code, :integer
    add_index :cities, :code, unique: true
    change_column :cities, :department, :string, limit: 3
    change_column :cities, :region, :string, limit: 50
  end
end
