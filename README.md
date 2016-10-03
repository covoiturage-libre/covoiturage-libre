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

* The look of an Itinerary, once migrated to the PostgreSQL Database
(tables itineraries and locations)

```
{
                :id => 726347,
              :kind => "Driver",
          :leave_at => #<DateTime: 2016-07-17T08:20:00+01:00 ((2457587j,26400s,0n),+3600s,2299161j)>,
             :seats => 3,
           :comfort => "basic",
       :description => "Bonjour!\r\nJe rentre enfin dans ma provence natale, ce serait un plaisir de faire le voyage avec vous, parce que c'est toujours plus sympas a plusieurs! Au plaisir de vous rencontrer! Pas de note spÃ©ciale concernant le trajet Ã  vous communiquer, si ce n'est qu'on fera autant de pauses que chacun dÃ©sirera. A bientÃ´t!",
             :price => 21,
             :title => "M",
           :smoking => false,
              :name => "Jordi",
               :age => "25",
             :email => "john.doe@email.com",
             :phone => "0606060606",
    :creation_token => "QdFHh50khv2duwne8E8ca4HgW",
     :edition_token => "M6lS61eaUhL8FVr20eP0Jgo1h",
    :deletion_token => "m6YZcGrGYooPs5ZfwRn2JyV96",
             :state => "confirmed",
       :creation_ip => "90.45.121.150",
       :deletion_ip => nil,
         :create_at => 2016-07-16 12:09:43 +0200,
        :updated_at => 2016-07-16 12:09:43 +0200,
         :locations => [
        [0] {
                        :kind => "From",
                     :trip_id => 726347,
                        :long => 1.433333,
                         :lat => 43.6,
                     :zipcode => "31000",
                        :city => "Toulouse",
            :country_iso_code => "FR",
                  :created_at => 2016-09-17 15:56:57 +0200,
                  :updated_at => 2016-09-17 15:56:57 +0200
        },
        [1] {
                        :kind => "To",
                :trip_id => 726347,
                   :lon => 5.633333,
                    :lat => 44.033333,
                     :zipcode => "04150",
                        :city => "Banon",
            :country_iso_code => "FR",
                  :created_at => 2016-09-17 15:56:57 +0200,
                  :updated_at => 2016-09-17 15:56:57 +0200
        },
        [2] {
                        :kind => "Step",
                        :rank => 1,
                :trip_id => 726347,
                   :lon => nil,
                    :lat => 43.610804,
                     :zipcode => "34000",
                        :city => "Montpellier",
            :country_iso_code => "FR",
                  :created_at => 2016-09-17 15:56:57 +0200,
                  :updated_at => 2016-09-17 15:56:57 +0200,
                       :price => 13
        },
        [3] {
                        :kind => "Step",
                        :rank => 2,
                     :trip_id => 726347,
                         :lon => nil,
                         :lat => 43.95,
                     :zipcode => "84000",
                        :city => "Avignon",
            :country_iso_code => "FR",
                  :created_at => 2016-09-17 15:56:57 +0200,
                  :updated_at => 2016-09-17 15:56:57 +0200,
                       :price => 16
        },
        [4] {
                        :kind => "Step",
                        :rank => 3,
                     :trip_id => 726347,
                         :lon => nil,
                         :lat => 43.883333,
                     :zipcode => "84400",
                        :city => "Apt",
            :country_iso_code => "FR",
                  :created_at => 2016-09-17 15:56:57 +0200,
                  :updated_at => 2016-09-17 15:56:57 +0200,
                       :price => 17
        }
    ]
}
```

* How to run the test suite

planning on using rspec

* Services (job queues, cache servers, search engines, etc.)

probably important later

* Deployment instructions

let's start on heroku
