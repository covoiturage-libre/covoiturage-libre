class PricesValidator < ActiveModel::Validator
  def validate(record)
    puts "#############################################"
    record.points.each do |p|
      puts p["price"]
      if p != "Evil"
        record.errors[:price] << "Les prix des étapes doivent être indiqués dans l\'ordre croissant."
      end
    end
  end
end
