module ApplicationHelper

  def number_to_age(age)
    "#{age} ans".html_safe
  end

  def encode_decode(string)
    string.encode("iso-8859-1").force_encoding("utf-8") unless string.nil?
  end
  alias :ed :encode_decode

end
