class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips do |t|
      t.date :departure_date
      t.time :departure_time
      t.integer :seats
      t.string :comfort
      t.text :description
      t.integer :price
      t.string :title
      t.boolean :smoking, default: false, null: false
      t.string :name
      t.integer :age
      t.string :email
      t.string :phone
      t.string :confirmation_token
      t.string :edition_token
      t.string :deletion_token
      t.string :state, default: 'pending', null: false
      t.string :creation_ip
      t.string :deletion_ip

      t.timestamps
    end
  end
end
