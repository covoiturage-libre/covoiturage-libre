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

def get_leave_at(date_parcours, heure)
  return nil if date_parcours.nil? || heure.nil?
  dt = DateTime.new(date_parcours.year, date_parcours.month, date_parcours.day, heure.hour, heure.min, heure.sec, heure.zone)
end

def get_comfort(confort)
  case confort
    when 'Basique'
      'basic'
    when 'Normal'
      'normal'
    when 'Confortable'
      'comfort'
    when 'Luxe'
      'luxe'
  end
end