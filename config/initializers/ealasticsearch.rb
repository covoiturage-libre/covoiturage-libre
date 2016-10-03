config = {
    host: "http://localhost:9200/",
    transport_options: {
        request: { timeout: 5 }
    },
}

if File.exists?("config/elasticsearch.yml")
  config.merge!(YAML.load_file("config/elasticsearch.yml").symbolize_keys)
elsif ENV['SCALINGO_ELASTICSEARCH_URL'].present?
  config = {
      host: ENV['SCALINGO_ELASTICSEARCH_URL'],
      transport_options: {
          request: { timeout: 5 }
      }
  }
end

Elasticsearch::Model.client = Elasticsearch::Client.new(config)