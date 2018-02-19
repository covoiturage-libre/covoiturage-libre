namespace :db do
  desc "Enable PostGIS"
  task enable_postgis: :environment do
    ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS postgis;')
  end
end
