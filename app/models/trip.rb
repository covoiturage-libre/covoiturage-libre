require 'elasticsearch/model'

class Trip < ApplicationRecord
  has_many :points

  ELASTICSEARCH_MAX_RESULTS = 25
  ELASTICSEARCH_GEO_DISTANCE = "10km"

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

  #
  # Trip.search({ from_coordinates: {}, to_coordinates: {}, date: Date })
  #
  def self.search(options = {})
    options ||= {}

    #logger.info options.inspect

    # empty search not allowed, for now
    return nil if options.blank?

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

    # only look for confirmed trips
    search_definition[:query][:bool][:must] << { term: { state: "confirmed" } }

    # root object criteria
    if options[:date].present?
      search_definition[:query][:bool][:must] << { range: { leave_at: { gte: options[:date].to_s } } }
    end

    # geo spatial query on nested document (point)
    if options[:from_coordinates].present? && options[:to_coordinates].present?
      search_definition[:query][:bool][:must] << nested_point_definition("From", options[:from_coordinates])
      search_definition[:query][:bool][:must] << nested_point_definition("To", options[:to_coordinates])
    end

    logger.info JSON.pretty_generate search_definition

    __elasticsearch__.search(search_definition)
  end

  private

    def self.nested_point_definition(kind, coordinates)
      {
          nested: {
              path: :points,
              query: {
                  bool: {
                    must: [
                        {
                            match: {
                              'points.kind': kind
                            }
                        },
                        {
                            geo_distance: {
                              distance: ELASTICSEARCH_GEO_DISTANCE,
                              'points.location': {
                                lat: coordinates[:lat],
                                lon: coordinates[:lon]
                              }
                            }
                        }
                    ]
                  }
              }
          }
      }
    end

end
