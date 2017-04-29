# README

CovoiturageLibre is a Carpooling Open Source platform, originally created for the French website https://covoiturage-libre.fr

It aims at providing a free, non-profit carpooling service for the shared economy, with no for-profit company controlling the service.

You can find the repository for the Android app just [here](https://github.com/serelion/covoiturage-libre-android).

[![Deploy on Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/covoiturage-libre/covoiturage-libre)
[![Deploy on Scalingo](https://cdn.scalingo.com/deploy/button.svg)](https://my.scalingo.com/deploy?source=https://github.com/covoiturage-libre/covoiturage-libre)

## Licence

 We are currently discussing under which license we want to publish the covoiturage-libre code. Any reuse of the code must go through a strong speech with the staff members, do not hesitate to open an "Issue" to discuss it. We want the widest federated Project as possible, avoiding forks that do not COMMUNICATE WITH US. (Thus, the proposed car-sharing will be better)

 The currently licence is the GNU GENERAL PUBLIC LICENSE v3.0, see LICENCE.

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

Enable PostGIS extension on your database via `bundle exec rake db:enable_postgis`.

Then you can run the migrations with `bundle exec rake db:migrate`

## Configuration

[Configuration ENV variables](https://github.com/covoiturage-libre/covoiturage-libre/wiki/Configuration-ENV-variables)

## Static pages

Some static pages are needed, normally created in the built-in CMS. The seedbank gem is used to import them (https://github.com/james2m/seedbank)

Just type :

`rake db:seed:pages`

to import them.

## Cities

You must import a cities in order to be able to find cities in the search engine. You can just create a few cities if you want to make it work for local development, or ask me for the 80000 cities of the databse if you want. Searchkick is used in the search engine.

## Setting up searchkick

We use searchkick as a search engine for Cities autocompletion.

Searchkick is based on elasticsearch, visit searchkick github page to set it up.

Once Elasticsearch is running, you have to index Geonames :

2 choices. Go in the console :

```
rails c
irb> City.reindex
```

or use the rake task :

```
rake searchkick:reindex CLASS=City
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
