require 'pg'

class ItineraryDestination
  # connect_url should look like;
  #  mysql://user:pass@localhost/dbname
  def initialize(connect_url)
    @conn = PG.connect(connect_url)
    @conn.prepare('insert_itinerary_stmt', 'insert into itineraries (id, leave_at, seats, comfort, description, price, title, smoking, name, age, email, phone, creation_token, edition_token, deletion_token, state, creation_ip, deletion_ip, created_at, updated_at) values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20)')
  end

  def write(row)
    time = Time.now
    @conn.exec_prepared('insert_itinerary_stmt', [
        row[:id],
        row[:leave_at],
        row[:seats],
        row[:comfort],
        row[:description],
        row[:price],
        row[:title],
        row[:smoking],
        row[:name],
        row[:age],
        row[:email],
        row[:phone],
        row[:creation_token],
        row[:edition_token],
        row[:deletion_token],
        row[:state],
        row[:creation_ip],
        row[:deletion_ip],
        row[:create_at],
        row[:updated_at]
    ])
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


