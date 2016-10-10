require 'elasticsearch/model'

class Trip < ApplicationRecord

  # use of this classification https://en.wikipedia.org/wiki/Hotel_rating
  CAR_RATINGS = %w(standard comfort first_class luxury)

  has_many :points, inverse_of: :trip, dependent: :destroy

  accepts_nested_attributes_for :points, reject_if: proc {|attrs| attrs[:location_name].blank? && attrs[:kind]=='Step' }

  validates_presence_of :departure_date, :departure_time, :price, :description, :title, :name, :age, :phone, :email, :seats, :comfort
  #validates_inclusion_of :comfort, in: CAR_RATINGS
  validates_numericality_of :price, :age, :seats
  validate :must_have_from_and_to_points

  # scopes

  # eager load points each time a trip is requested
  default_scope { includes(:points).order('created_at ASC') }

  # access the departure point that comes eager loaded with a trip
  def point_from
    points.find { |point| point.kind == 'From' }
  end

  # access the destination point that comes eager loaded with a trip
  def point_to
    points.find { |point| point.kind == 'To' }
  end

  # access the steps point that comes eager loaded with a trip
  def step_points
    points.select { |point| point.kind == 'Step' }
  end


  ### ELASTICSEARCH SECTION

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

    # pretty log for json elasticsearch request (do not delete)
    #logger.info JSON.pretty_generate search_definition

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

    def must_have_from_and_to_points
      logger.info errors.full_messages
      if points.empty? or point_from.nil? or point_to.nil?
        errors.add(:base, "Le départ et l'arrivée du voyage sont nécessaires")
      end
    end

end
