class AddFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :display_name, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :telephone, :string
    add_column :users, :gender, :string, limit: 1, null: false, default: :h
  end
end
