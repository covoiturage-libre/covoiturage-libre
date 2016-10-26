require 'pg'

class TripDestination
  # connect_url should look like;
  #  mysql://user:pass@localhost/dbname
  def initialize(connect_url)
    @conn = PG.connect(connect_url)
    @conn.prepare('insert_trip_stmt', 'insert into trips (id, departure_date, departure_time, seats, comfort, description, price, title, smoking, name, age, email, phone, confirmation_token, edition_token, deletion_token, state, creation_ip, deletion_ip, created_at, updated_at) values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21)')
    @conn.prepare('insert_point_stmt', 'insert into points (id, kind, rank, trip_id, address1, address2, city, zipcode, country_iso_code, created_at, updated_at, lat, lon) values (default, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)')
  end

  def write(row)
    @conn.exec_prepared('insert_trip_stmt', [
        row[:id],
        row[:departure_date],
        row[:departure_time],
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
    row[:points].each do |point|
      @conn.exec_prepared('insert_point_stmt', [
          point[:kind],
          point[:rank],
          point[:trip_id],
          point[:address1],
          point[:address2],
          point[:city],
          point[:zipcode],
          point[:country_iso_code],
          point[:created_at],
          point[:updated_at],
          point[:lat],
          point[:lon]
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
