class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  def strip_value(value)
    value.force_encoding('UTF-8').strip unless value.nil?
  end
end
