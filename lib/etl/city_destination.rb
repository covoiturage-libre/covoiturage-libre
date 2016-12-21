require 'pg'

class TripDestination
  # connect_url should look like;
  #  mysql://user:pass@localhost/dbname
  def initialize(connect_url)
    @conn = PG.connect(connect_url)
    @conn.prepare('insert_city_stmt', 'insert into cities (id, name, postal_code, department, region, country_code, lat, lon, distance, created_at, updated_at) values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)')
  end

  def write(row)
    @conn.exec_prepared('insert_city_stmt', [
      row[:id],
      row[:name],
      row[:postal_code],
      row[:department],
      row[:region],
      row[:country_code],
      row[:lat],
      row[:lon],
      row[:distance],
      row[:create_at],
      row[:updated_at]
    ])
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
