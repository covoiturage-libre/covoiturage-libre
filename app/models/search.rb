class Search
  include ActiveModel::Model

  attr_accessor(
      :from_name,
      :from_coordinates,
      :to_name,
      :to_coordinates,
      :date
  )

  validates_presence_of :from_coordinates, :to_coordinates, :date

  def short_from_name
    from_name.split(', ').first
  end

  def short_to_name
    to_name.split(', ').first
  end

end