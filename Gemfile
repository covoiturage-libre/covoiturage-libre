source 'https://rubygems.org'
ruby '>= 2.2.2'

### Main Gems

gem 'rails', '~> 5.0', '< 5.1' # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'

### Database

gem 'pg', '~> 0.18' # Use postgresql + postgis as the database for Active Record
gem 'kaminari' # for pagination
gem 'delayed_job_active_record'
gem 'searchkick'
gem 'seedbank'
gem 'seed_dump'
gem 'groupdate'

### Searchkick Tools
gem 'oj' # Significantly increase performance with faster JSON generation
gem 'typhoeus' # Significantly increase performance with persistent HTTP connections

### for ETL job only > delete after platform migration

gem 'kiba' # the awesome ETL tool
gem 'mysql2', '~> 0.4' # for kiba migrations
gem 'awesome_print'

### App Server

gem 'puma', '~> 3.6' # Use Puma as the app server
gem 'daemons' # for running delayed jobs

### Middlewares

gem 'rack-rewrite'

### Front tools

gem 'bootstrap-sass'
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'kaminari-bootstrap'
gem 'uglifier', '~> 3.0' # Use Uglifier as compressor for JavaScript assets
gem 'jquery-rails', '~> 4.2' # Use jquery as the JavaScript library
gem 'turbolinks', '~> 5.0' # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'jbuilder', '~> 2.6' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'haml'
gem 'simple_form'
gem 'jquery-ui-rails'
gem 'cocoon'
gem 'active_link_to'
gem 'font-awesome-sass'
gem 'chartkick'

### Authentication
gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'domp'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

### i18n

gem 'route_translator'

### Services

gem 'mailjet'
gem 'sentry-raven' # Errors tracking

### Image manipularion

gem 'dragonfly' # TODO remove if not in use

### Markdown Rendering

gem 'redcarpet' # Require the Markdown converter gem

### Other Gems

# gem 'redis', '~> 3.0' # Use Redis adapter to run Action Cable in production
# gem 'bcrypt', '~> 3.1.7' # Use ActiveModel has_secure_password

gem 'activerecord-postgis-adapter'

group :development, :test do
  gem 'byebug', '~> 9.0', platform: :mri # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'rspec', '~> 3.5'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'email_spec'
end

group :development do
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'web-console', '~> 3.3' # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0'
  gem 'spring', '~> 1.7' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'rails_12factor' # needed for scalingo
