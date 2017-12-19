
require 'elasticsearch/transport'

ENV['ELASTICSEARCH_URL'] ||= ENV['SCALINGO_ELASTICSEARCH_URL'] || ENV['SEARCHBOX_SSL_URL'] || ENV['SEARCHBOX_URL']
 
client = Elasticsearch::Client.new transport_options: { ssl: { verify: false } }
