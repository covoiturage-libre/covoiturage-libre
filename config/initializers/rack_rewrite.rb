Rails.application.config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do

  # Redirect all http traffic to https
  r301 %r{.*}, 'https://covoiturage-libre.fr$&', scheme: 'http'

  r301 '/association_descriptif.php', '/association'
  r301 '/recherche.php', '/rechercher'
  r301 '/stickers.php', '/stickers'
  r301 '/presse.php', '/presse'
  r301 '/faq.php', '/faq'
  r301 '/contact.php', '/contact'
  r301 '/mentions-legales.php', '/mentions-legales'

  r301 '/nouveau.php', '/trajets/nouveau'

  r301 %r{/detail\.php\?c=(\w+).*}, '/trajets/$1'
  r301 %r{/validation\.php\?c=(\w+).*}, '/trajets/$1/confirmer'
  r301 %r{/modification\.php\?m=(\w+).*}, '/trajets/$1/editer'
  r301 %r{/suppression\.php\?supp=(\w+).*}, '/trajets/$1/supprimer'

  r301 %r{/nouveau\.php\?c=(\w+)\&a\=r\&c2\=.+}, '/trajets/$1/creer_retour'
  r301 %r{/nouveau\.php\?c=(\w+)\&a\=d\&c2\=.+}, '/trajets/$1/dupliquer'

end