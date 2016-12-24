class Search
  include ActiveModel::Model

  attr_accessor(
      :from_city,
      :from_lon,
      :from_lat,
      :to_city,
      :to_lon,
      :to_lat,
      :date
  )

  validate :dont_search_the_past

  def complete_missing_params
    if date.blank?
      self.date = Date.today.strftime('%d/%m/%Y')
    end
    self
  end

  def date_value
    if date.present?
      Date.strptime(self.date, '%d/%m/%Y')
    else
      nil
    end
  end

  private

    def dont_search_the_past
      if date.present? && date_value < Date.today
        errors.add(:date, "Cherchez une date future")
      end
    end

end
