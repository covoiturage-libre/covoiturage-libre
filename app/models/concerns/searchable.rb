#
# Supposed to be included in Trip
# but Elasticsearch use is being pause because of that issue :
#
#
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    ELASTICSEARCH_MAX_RESULTS = 25
    ELASTICSEARCH_GEO_DISTANCE = "10km"

    mapping do
      indexes :seats,            type: 'integer'
      indexes :comfort,          type: 'string'
      indexes :state,            type: 'string'
      indexes :departure_date,   type: 'date'
      indexes :points, type: 'nested' do
        indexes :kind,             type: 'string'
        indexes :rank,             type: 'string'
        indexes :location,         type: 'geo_point'
        indexes :city,             type: 'string'
      end
    end

    after_commit on: [:create] do
      __elasticsearch__.index_document
    end

    after_commit on: [:update] do
      __elasticsearch__.update_document
    end


    def as_indexed_json(options = {})
      self.as_json(
          { only: [:seats, :comfort, :state, :departure_date] }
      ).merge(
          points: points.as_json
      )
    end

    #
    # Trip.search({ from_coordinates: {}, to_coordinates: {}, date: Date })
    #
    def self.search(options = {})
      options ||= {}

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
        search_definition[:query][:bool][:must] << { range: { departure_date: { gte: options[:date].to_s } } }
      end

      # geo spatial query on nested document (point)
      if options[:from_coordinates].present? && options[:to_coordinates].present?
        search_definition[:query][:bool][:must] << nested_point_definition("From", options[:from_coordinates])
        search_definition[:query][:bool][:must] << nested_point_definition("To", options[:to_coordinates])
      end

      # pretty log for json elasticsearch request (do not delete)
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
end

