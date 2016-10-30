class CreateGeonames < ActiveRecord::Migration[5.0]
  def up
    create_table :geonames do |t|
      t.string :country_code, limit: 2
      t.string :postal_code, limit: 20
      t.string :place_name, limit: 180, index: true
      t.string :admin_name1, limit: 100
      t.string :admin_code1, limit: 20
      t.string :admin_name2, limit: 100
      t.string :admin_code2, limit: 20
      t.string :admin_name3, limit: 100
      t.string :admin_code3, limit: 20
      t.decimal :latitude, precision: 9, scale: 6
      t.decimal :longitude, precision: 9, scale: 6
      t.integer :accuracy
    end
  end

  def down
    drop_table :geonames
  end
end
