class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.strip =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "n'est pas un email valide")
    end
  end
end

