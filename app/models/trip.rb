require 'elasticsearch/model'

class Trip < ApplicationRecord
  has_many :points

  ELASTICSEARCH_MAX_RESULTS = 25

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include Elasticsearch::Model::Indexing

  mappings do

  end

  mappings do
    indexes :seats,      type: 'integer'
    indexes :comfort,    type: 'string'
    indexes :state,      type: 'string'
    indexes :points do
      indexes :kind,       type: 'string'
      indexes :rank,       type: 'string'
      indexes :latlon,     type: 'geo_point'
      indexes :city,       type: 'string'
    end
  end

  def as_indexed_json
    self.as_json({ only: [:seats, :comfort, :state] }).merge( points: points.as_json)
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

    # query
    if query.present?
      search_definition[:query][:bool][:must] << {
          multi_match: {
              query: query,
              fields: { points: [:city]},
              operator: 'and'
          }
      }
    end

    # geo spatial
    if options[:lat].present? && options[:lon].present?
      options[:distance] ||= 100

      search_definition[:query][:bool][:must] << {
          filtered: {
              filter: {
                  geo_distance: {
                      distance: "#{options[:distance]}mi",
                      location: {
                          lat: options[:lat].to_f,
                          lon: options[:lon].to_f
                      }
                  }
              }
          }
      }
    end

    __elasticsearch__.search(search_definition)
  end

end
