release: bin/rails db:enable_postgis db:migrate
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bin/delayed_job run
