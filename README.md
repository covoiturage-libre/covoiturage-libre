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

`elasticsearch 2.4`

* Configuration

Create a database.yml file

`cp config/database.yml.example config/database.yml`

NB : a simple postgresql config file does the jobs. The adapter is `postgis` but `postgresql` works as well.


* Database creation

`bundle exec rake db:create`

* Database initialization

Install postgis extension on your database :

```
user=> CREATE extension postgis;
CREATE EXTENSION
```
Then you can run the migrations

`bundle exec rake db:migrate`

* Import geonames

We use Geonames to search for cities in the app as we aim at using open technologies only
For more information, visit the geoname website http://www.geonames.org/

We use the excellent Kiba gem for ETL operations such as importing geonames data or importing
legacy covoiturage-libre.fr data.

Kiba files are located in `./lib/etl/`

I host publicly unzipped city files at this bucket on AWS s3 : https://s3-eu-west-1.amazonaws.com/covoli/
Country files are FR.txt, BE.txt, CH.txt, etc.
So for each fil you want to import, you have to run :

`GEONAMES_URL='https://s3-eu-west-1.amazonaws.com/covoli/CH.txt' kiba ./lib/etl/import_geonames.etl`

* Setting up searchkick

We use searchkick as a search engine for Geonames autocompletion.

Searchkick is based on elasticsearch, visit searchkick github page to set it up.

Once Elasticsearch is running, you have to index Geonames :

```
rails c
irb> Geoname.reindex
```

* Delayed jobs

We use delayed_jobs_activerecord to process asynchronous jobs like delivering email.

You have to run it with the command :

`./bin/delayed_job start`

* How to run the test suite

planning on using rspec

* Services (job queues, cache servers, search engines, etc.)

in order to make the emails delivered, you have to start delayed_jobs

`./bin/delayed_jobs start`
