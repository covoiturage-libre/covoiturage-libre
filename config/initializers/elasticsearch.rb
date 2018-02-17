require 'elasticsearch/transport'

ENV['ELASTICSEARCH_URL'] ||= ENV['SCALINGO_ELASTICSEARCH_URL'] || ENV['SEARCHBOX_SSL_URL'] || ENV['SEARCHBOX_URL']

Elasticsearch::Client.new transport_options: {
  request_timeout: 30, # seconds
  ssl: { verify: false }
}
