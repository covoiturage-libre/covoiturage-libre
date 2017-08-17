namespace :db do
  desc "Enable PostGIS"
  task enable_postgis: :environment do
    ActiveRecord::Base.connection.execute('CREATE EXTENSION postgis;')
  end
end
