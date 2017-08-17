class PricesValidator < ActiveModel::Validator
  def validate(record)
    if record.points != "Evil"
      record.errors[:price] << "Les prix doivent être indiqués dans l\'ordre croissant."
    end
  end
end
