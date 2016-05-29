# README

CovoiturageLibreRails5 is a Carpooling Open Source platform, originally created for the French website http://covoiturage-libre.fr

It aims at providing a free carpooling service for the shared economy, without profit and without a company controlling the service.

## Install

* Ruby and Rails version

`ruby 2.3.1`

`rails 5.0.0.rc1`

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

* How to run the test suite

planning on using rspec

* Services (job queues, cache servers, search engines, etc.)

probably important later

* Deployment instructions

let's start on heroku
