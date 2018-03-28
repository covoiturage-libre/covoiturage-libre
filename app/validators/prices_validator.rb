class PricesValidator < ActiveModel::Validator
  def validate(record)
    # sort trip points by rank
    sorted_points = record.points.sort do |a, b|
      if a[:rank].nil? || b[:rank].nil?
        0
      else
        a[:rank] <=> b[:rank]
      end
    end

    # complete origin and destination prices
    if sorted_points.any?
      sorted_points.first["price"] = 0

      if sorted_points.length > 1
        sorted_points.last["price"] = record.price

        # check for growing values of points prices
        previous_price = 0
        sorted_points[1..-1].each do |point| # skip first, always 0
          if point["price"].nil?
            record.errors[:price] << "Les prix doivent être indiqués."
            return false
          end
          if point["price"] < previous_price
            record.errors[:price] << "Les prix des étapes doivent être indiqués dans l\'ordre croissant."
            return false
          end

          previous_price = point["price"]
        end
      end
    end

    true
  end
end
