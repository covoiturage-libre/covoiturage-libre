require 'elasticsearch/transport'

ENV['ELASTICSEARCH_URL'] ||= ENV['SCALINGO_ELASTICSEARCH_URL'] || ENV['SEARCHBOX_SSL_URL'] || ENV['SEARCHBOX_URL']

Elasticsearch::Client.new transport_options: {
  request: { open_timeout: ENV.fetch('ELASTICSEARCH_TIMEOUT', 30).to_i }, # seconds
  ssl: { verify: false }
}
