require 'csv'

class City < ApplicationRecord

  searchkick locations: [:location],
             text_start: [:name, :postal_code],
             word_start: [:name, :postal_code],
             searchable: [:name, :postal_code],
             highlight: [:name, :postal_code]

  def search_data
    attributes.merge location: { lat: lat, lon: lon }
  end

  def self.import_csv(csv_text)
    csv = CSV.parse(csv_text, headers: true, col_sep: ',')

    self.transaction do
      csv.each do |row|
        h           = row.to_hash

        city = self.find_or_initialize_by(code: h['insee'])

        city.name = h['VILLE']
        city.postal_code = h['code postal'].split(' ').first
        city.department = h['dep']
        city.region = h['nom region']
        city.country_code = 'FR'
        city.lat = h['latitude']
        city.lon = h['longitude']
        city.distance = 1.00

        city.save!
      end
    end
  end

end
