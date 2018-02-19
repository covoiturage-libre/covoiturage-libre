require 'pg'

# simple destination assuming all rows have the same fields
class GeonameDestination

  def initialize(connect_url)
    @conn = PG.connect(connect_url)
    @conn.prepare('insert_geonames_stmt', 'insert into geonames (country_code, postal_code, place_name, admin_name1, admin_code1, admin_name2, admin_code2, admin_name3, admin_code3, latitude, longitude, accuracy) values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)')
    @now = Time.now
  end

  def write(row)
    @conn.exec_prepared('insert_geonames_stmt', [
        row[0], # country_code,
        row[1], # postal_code,
        row[2], # place_name,
        row[3], # admin_name1,
        row[4], # admin_code1,
        row[5], # admin_name2,
        row[6], # admin_code2,
        row[7], # admin_name3,
        row[8], # admin_code3,
        row[9], # latitude,
        row[10], # longitude,
        row[11] # accuracy
    ])
  end

  def close
    @conn.close
    @conn = nil
  end
end