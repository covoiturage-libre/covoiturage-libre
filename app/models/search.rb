class Search
  include ActiveModel::Model

  attr_accessor(
      :from_name,
      :from_coordinates,
      :to_name,
      :to_coordinates,
      :date
  )
end