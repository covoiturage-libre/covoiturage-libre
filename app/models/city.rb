class City < ApplicationRecord
  searchkick word_start: [:name]
end
