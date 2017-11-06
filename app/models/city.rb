class City < ApplicationRecord

  searchkick locations: [:location],
             word_start: [:name, :postal_code],
             searchable: [:name, :postal_code],
             highlight: [:name, :postal_code]

  def search_data
    attributes.merge location: { lat: lat, lon: lon }
  end

end
