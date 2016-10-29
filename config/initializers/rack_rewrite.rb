Rails.application.config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
  r301 '/association_descriptif.php', '/association'
  r301 '/recherche.php', '/rechercher'
end