# coding: utf-8
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
  validate :do_select_a_city_in_the_list

  def date_value
    # dans le @search : '%d/%m/%Y'
    # date en texte de type : "vendredi 13 mai 2011" : 4 chiffres -> l'année ; 1 ou 2 chiffres -> le jour ; le mois en lettres est dans I18n.t('date.month_names'), .index("mois en lettres") donne le mois en chiffres
    #begin
    #Date.strptime(self.date, '%d/%m/%Y')
    begin
      the_day_name_in_text, the_day_number_in_text, the_month_in_text, the_year_in_text = self.date.split(/ +/)
      the_day_in_digits = Integer(the_day_number_in_text)
      the_year_in_digits = Integer(the_year_in_text)
      the_month_in_digits = I18n.t('date.month_names').index(the_month_in_text.downcase)
      Date.new(the_year_in_digits, the_month_in_digits, the_day_in_digits)
    rescue
      Date.today
    end
  end

  private

    def dont_search_the_past
      @date = I18n.localize(Date.today, :format => '%A %d %B %Y') if @date.blank?
      if self.date_value < Date.today
        #errors.add(:date, "Cherchez une date future")
        @date = I18n.localize(Date.today, :format => '%A %d %B %Y')
      end
    end

    def do_select_a_city_in_the_list
      if @from_city.present? && @from_lon.blank?
        errors.add(:from_city, "Selectionnez une ville *dans* la liste")
      end
      if @to_city.present? && @to_lon.blank?
        errors.add(:to_city, "Selectionnez une ville *dans* la liste")
      end
    end

end
