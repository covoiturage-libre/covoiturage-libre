require 'pg'

class ItineraryDestination
  # connect_url should look like;
  #  mysql://user:pass@localhost/dbname
  def initialize(connect_url)
    @conn = PG.connect(connect_url)
    @conn.prepare('insert_itinerary_stmt', 'insert into itineraries (id, kind, leave_at, seats, comfort, description, price, title, smoking, name, age, email, phone, creation_token, edition_token, deletion_token, state, creation_ip, deletion_ip, created_at, updated_at) values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21)')
    @conn.prepare('insert_location_stmt', 'insert into locations (id, kind, rank, itinerary_id, address1, address2, city, zipcode, country_iso_code, created_at, updated_at, latitude, longitude) values (default, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)')

  end

  def write(row)
    @conn.exec_prepared('insert_itinerary_stmt', [
        row[:id],
        row[:kind],
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
    row[:locations].each do |location|
      @conn.exec_prepared('insert_location_stmt', [
          location[:kind],
          location[:rank],
          location[:itinerary_id],
          location[:address1],
          location[:address2],
          location[:city],
          location[:zipcode],
          location[:country_iso_code],
          location[:created_at],
          location[:updated_at],
          location[:latitude],
          location[:longitude]
      ])
    end
  rescue PG::Error => ex
    message = "ERROR for #{row[:id]} : #{ex.message}"
    puts message
    File.open('log/etl_errors.log', 'a+') { |file| file.write(message) }
  end

  def close
    @conn.close
    @conn = nil
  end
end
