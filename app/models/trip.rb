require 'elasticsearch/model'

class Trip < ApplicationRecord
  has_many :points

  ELASTICSEARCH_MAX_RESULTS = 25

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include Elasticsearch::Model::Indexing

  mappings do
    indexes :seats,      type: 'integer'
    indexes :comfort,    type: 'string'
    indexes :state,      type: 'string'
    indexes :leave_at,   type: 'date'
    indexes :points, type: 'nested' do
      indexes :kind,       type: 'string'
      indexes :rank,       type: 'string'
      indexes :location,   type: 'geo_point'
      indexes :city,       type: 'string'
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
        { only: [:seats, :comfort, :state, :leave_at] }
    ).merge(
        points: points.as_json
    )
  end


  def self.search(query = nil, options = {})
    options ||= {}

    # empty search not allowed, for now
    return nil if query.blank? && options.blank?

    # define search definition
    search_definition = {
        query: {
            bool: {
                must: []
            }
        }
    }

    unless options.blank?
      search_definition[:from] = 0
      search_definition[:size] = ELASTICSEARCH_MAX_RESULTS
    end

    # query on root document (trip)
    if query.present?
      search_definition[:query][:bool][:must] << {
          match: {
              seats: options[:seats],
              comfort: options[:comfort],
              state: options[:state],
              leave_at: options[:leave_at],
          }
      }
    end

    # geo spatial query on nested document (point)
    if options[:lat].present? && options[:lon].present?
      options[:distance] ||= 100

      search_definition[:query][:bool][:must] << {
          nested: {
              path: :points,
              query: {
                  bool: {
                      must: [
                          match: {
                              city: query
                          }
                      ]
                  },
                  filtered: {
                      filter: {
                          geo_distance: {
                              distance: "#{options[:distance]}km",
                              location: {
                                  lat: options[:lat].to_f,
                                  lon: options[:lon].to_f
                              }
                          }
                      }
                  }
              }
          }
      }

    end

    __elasticsearch__.search(search_definition)
  end

end
