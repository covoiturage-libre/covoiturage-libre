Rails.application.config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
  r301 '/association_descriptif.php', '/association'
  r301 '/recherche.php', '/rechercher'
  r301 '/stickers.php', '/stickers'
  r301 '/presse.php', '/presse'
  r301 '/faq.php', '/faq'
  r301 '/contact.php', '/contact'
  r301 '/mentions-legales.php', '/mentions-legales'
end