class Point < ApplicationRecord

  KINDS = %w( From Step To ).freeze

  belongs_to :trip, inverse_of: :points

  validates_presence_of :kind, :rank, :trip, :lat, :lon, :city
  validates_inclusion_of :kind, in: KINDS
  validates_numericality_of :rank
  validate :lat_lon_must_be_set
  validates :price, presence: true, if: Proc.new { |p| p.kind == 'Step' },
                    numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_from_rank, :set_to_rank

  private

    def lat_lon_must_be_set
      if lat.blank? or lon.blank?
        errors.add(:city, "Vous devez sélectionner une ville dans la liste")
      end
    end


    def set_from_rank
      self.rank = 0 if self.kind == 'From'
    end

    def set_to_rank
      # nb max of steps = rank -1
      self.rank = 16 if self.kind == 'To'
    end

end
