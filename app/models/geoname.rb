class Geoname < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_name,
                  against: :place_name,
                  using: {
                      tsearch: {
                          prefix: true,
                          highlight: {
                              start_sel: '<b>',
                              stop_sel: '</b>'
                          }
                      }
                  }
end
