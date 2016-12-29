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

  def date_value
    Date.strptime(self.date, '%d/%m/%Y')
  end

  private

    def dont_search_the_past
      @date = Date.today.strftime('%d/%m/%Y') if @date.blank?
      if self.date_value < Date.today
        errors.add(:date, "Cherchez une date future")
      end
    end

end
