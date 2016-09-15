class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :kind
      t.integer :rank
      t.references :itinerary, foreign_key: true
      #t.st_point :lonlat commented that for deployment purposes
      t.string :address1
      t.string :address2
      t.string :city
      t.string :zipcode
      t.string :country_iso_code

      t.timestamps
    end
  end
end
