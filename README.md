# README

CovoiturageLibre is a Carpooling Open Source platform, originally created for the French website https://covoiturage-libre.fr

It aims at providing a free, non-profit carpooling service for the shared economy, with no for-profit company controlling the service.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/covoiturage-libre/covoiturage-libre)

## Licence

 GNU GENERAL PUBLIC LICENSE v3.0, see LICENCE.

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

## Config via ENV

- `BUNDLE_GEMFILE`
- `DATABASE_URL`
- `ELASTICSEARCH_URL` : required
- `FACEBOOK_CLIENT_ID` : optional, for Meta data and Facebook login
- `FACEBOOK_CLIENT_SECRET` : optional
- `GA_TRACKING_ID` : optional, Google Analytics
- `GEONAMES_URL` : optional, for import only
- `GOOGLE_CLIENT_ID` : optional
- `GOOGLE_CLIENT_SECRET` : optional
- `MAILER_HOST`
- `MAILJET_API_KEY`
- `MAILJET_API_SECRET`
- `MYSQL_URL` : optional, for import only
- `PG_URL` : optional, for import only
- `RAILS_ENV`
- `RAILS_LOG_TO_STDOUT`
- `RAILS_SERVE_STATIC_FILES`
- `REDIRECT_ALL_TRAFFIC` : optional
- `SECRET_KEY_BASE` : required
- `SERVER_NAME` : optional, for redirects only
- `SLAASK_WIDGET_KEY` : optional, for visitors chat with you

## Enable Postgis on PostgreSQL

`rake db:enable_postgis`

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
