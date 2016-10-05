# README

CovoiturageLibreRails5 is a Carpooling Open Source platform, originally created for the French website http://covoiturage-libre.fr

It aims at providing a free carpooling service for the shared economy, without profit and without a company controlling the service.

## Install

* Ruby and Rails version

`ruby 2.3.1`

`rails 5.0.0`

* System dependencies (versions originally used on this project)

`postgresql 9.5.3`

`postgis 2.2.2`

* Configuration

Create a database.yml with postgis adapter

`cp config/database.yml.example config/database.yml`

* Database creation

`bundle exec rake db:create`

* Database initialization

`bundle exec rake db:migrate`

* Import the data

We use the ETL gem Kiba to migrate the data from mysql to postgresql

You need a MySQL server running

Import the table trajets.sql

Then make sure you configure the data source (mysql) and the data destination (postgresql) for Kiba

```
# .env file with dotenv
export MYSQL_URL=mysql://root@localhost:3306/covoiturage-libre-rails5_dev
export PG_URL=postgres://thb@localhost:5432/covoiturage-libre-rails5_dev
```

Then run the command to migrate the data from source into destination 

```
bundle exec kiba ./lib/etl/migrate_trips.etl
```

* How to run the test suite

planning on using rspec

* Services (job queues, cache servers, search engines, etc.)

probably important later

* Deployment instructions

let's start on heroku
