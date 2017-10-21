class PricesValidator < ActiveModel::Validator
  def validate(record)
    # sort trip points by rank
    sorted_points = record.points.sort_by { |aoh| aoh[:rank] }
    # complete origin and destination prices
    sorted_points[0]["price"] = 0
    sorted_points[-1]["price"] = record.price
    # check for growing values of points prices
    i = 0
    sorted_points.each do |p|
      if p["price"] == nil
        record.errors[:price] << "Les prix doivent être indiqués."
        break
      end
      if p["price"] < i
        record.errors[:price] << "Les prix des étapes doivent être indiqués dans l\'ordre croissant."
        break
      end
      i = p["price"]
    end
  end
end
