require "awesome_print"

def show_me!
  transform do |row|
    ap row
    row
  end
end

def limit(x)
  transform do |row|
    @counter ||= 0
    @counter += 1
    abort('Stopping...') if @counter > x
    row
  end
end

def get_state(statut)
  case statut
    when 'En attente'
      'pending'
    when 'Valide'
      'confirmed'
    when 'Supprime'
      'deleted'
  end
end

def get_title(civilite)
  case civilite
    when 'homme'
      'M'
    when 'femme'
      'F'
  end
end

def get_kind(type)
  case type
    when 'Conducteur'
      'Driver'
    when 'Passager'
      'Passenger'
  end
end

def get_departure_date(date_parcours)
  return nil if date_parcours.nil?
  Date.new(date_parcours.year, date_parcours.month, date_parcours.day)
end

def get_departure_time(date_parcours, heure)
  return nil if date_parcours.nil? || heure.nil?
  Time.new(date_parcours.year, date_parcours.month, date_parcours.day, heure.hour, heure.min, heure.sec)
end

def get_comfort(confort)
  case confort
    when 'Basique'
      'standard'
    when 'Normal'
      'comfort'
    when 'Confortable'
      'first_class'
    when 'Luxe'
      'luxury'
  end
end

def encode_decode(string)
  begin
    string.encode("iso-8859-1").force_encoding("utf-8") unless string.nil?
  rescue
    string
  end
end
alias :ed :encode_decode