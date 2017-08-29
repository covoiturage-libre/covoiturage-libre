namespace :db do
  desc "Enable PostGIS"
  task enable_postgis: :environment do
    ActiveRecord::Base.connection.execute('CREATE EXTENSION postgis;') rescue nil
  end
end
