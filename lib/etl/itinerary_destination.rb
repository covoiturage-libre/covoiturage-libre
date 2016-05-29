require 'pg'

class ItineraryDestination
  # connect_url should look like;
  #  mysql://user:pass@localhost/dbname
  def initialize(connect_url)
    @conn = PG.connect(connect_url)
    @conn.prepare('insert_itinerary_stmt', 'insert into itineraries (email, password_digest, created_at, updated_at) values ($1, $2, $3, $4)')
  end

  def write(row)
    time = Time.now
    @conn.exec_prepared('insert_itinerary_stmt',
                        [ row[:email], row[:password], row[:date_created], time ])
  rescue PG::Error => ex
    puts "ERROR for #{row[:email]}"
    puts ex.message
    # Maybe, write to db table or file
  end

  def close
    @conn.close
    @conn = nil
  end
end