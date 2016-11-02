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

## Import geonames

We use Geonames to search for cities in the app as we aim at using open technologies only
For more information, visit the geoname website http://www.geonames.org/

We use the excellent Kiba gem for ETL operations such as importing geonames data or importing
legacy covoiturage-libre.fr data.

Kiba files are located in `./lib/etl/`

I host publicly unzipped city files at this bucket on AWS s3 : https://s3-eu-west-1.amazonaws.com/covoli/
Country files are FR.txt, BE.txt, CH.txt, etc.
So for each fil you want to import, you have to run :

`GEONAMES_URL='https://s3-eu-west-1.amazonaws.com/covoli/CH.txt' kiba ./lib/etl/import_geonames.etl`

Geonames come with a lot of duplicates. For instance, there is about 100 records for Pris only, because of the number of "arrondissements" and different postcodes in the French administrative system for its capital. Other countries have the same issue. So to remove duplicates, you can run these requests in the Postgresql console.

```
DELETE FROM GEONAMES WHERE place_name SIMILAR TO '% ([0-9][0-9])';

DELETE FROM geonames g1 USING geonames g2
  WHERE g1.place_name = g2.place_name
  AND   g1.admin_name1 = g2.admin_name1
  AND   g1.admin_code1 = g2.admin_code1
  AND   g1.admin_name2 = g2.admin_name2
  AND   g1.admin_code2 = g2.admin_code2
  AND   g1.id > g2.id;
```

Each time you add a country or modify by SQL the geonames table, don't forget to reindex data in Searchkick as explained in the next section.

## Setting up searchkick

We use searchkick as a search engine for Geonames autocompletion.

Searchkick is based on elasticsearch, visit searchkick github page to set it up.

Once Elasticsearch is running, you have to index Geonames :

2 choices. Go in the console :

```
rails c
irb> Geoname.reindex
```

or use the rake task :

```
rake searchkick:reindex CLASS=Geoname
```

## Delayed jobs

We use delayed_jobs_activerecord to process asynchronous jobs like delivering email.

You have to run it with the command :

`./bin/delayed_job start`

## How to run the test suite

planning on using rspec

## Services (job queues, cache servers, search engines, etc.)

in order to make the emails delivered, you have to start delayed_jobs

`./bin/delayed_jobs start`

elasticsearch should be running

2 choices for searchkick without extra configuration :

```ELASTICSEARCH_URL``` should be set (in production)

or it is going to look for ```http:/localhost:9002```
