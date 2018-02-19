class CreatePoints < ActiveRecord::Migration[5.0]
  def change
    create_table :points do |t|
      t.string :kind
      t.integer :rank
      t.references :trip, foreign_key: true
      t.decimal :lat, precision: 9, scale: 6
      t.decimal :lon, precision: 9, scale: 6
      t.string :address1
      t.string :address2
      t.string :city
      t.string :zipcode
      t.string :country_iso_code
      t.integer :price

      t.timestamps
    end
  end
end
