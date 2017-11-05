class Geoname < ApplicationRecord
  searchkick word_start: [:place_name]
end
