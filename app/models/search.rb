class Search
  include ActiveModel::Model

  attr_accessor(
      :from,
      :from_coordinates,
      :to,
      :to_coordinates,
      :date
  )
end