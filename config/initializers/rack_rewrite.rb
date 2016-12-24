Rails.application.config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do

  # Redirect all http traffic to https
  if ENV['REDIRECT_ALL_TRAFFIC'].present?
    r301 %r{.*}, 'https://covoiturage-libre.fr$&', scheme: 'http'
  end

  # static pages
  r301 '/association_descriptif.php', '/association'
  r301 '/infos.php', 'http://wiki.covoiturage-libre.fr/index.php?title=Accueil'
  r301 '/presse.php', '/presse'
  r301 '/mentions-legales.php', '/mentions-legales'
  r301 '/association.php', 'https://www.helloasso.com/associations/covoiturage-libre-fr/collectes/campagne-courante/'
  r301 '/missions.php', 'missions-benevoles'
  r301 '/contact.php', '/contact'
  r301 '/bug.php', 'bug'
  r301 '/manif_14juin.php', 'manif_14juin'
  r301 '/stickers.php', '/stickers'
  r301 '/pourquoi.php', 'http://wiki.covoiturage-libre.fr/index.php?title=Le_covoiturage_est_un_bien_commun'
  r301 '/faq.php', '/faq'
  r301 '/metamoteur.php', '/metamoteur' # TODO transfer this page on the wiki ?

  # dynamic pages
  r301 '/recherche.php', '/rechercher'
  r301 '/nouveau.php', '/trajets/nouveau'

  r301 %r{/detail\.php\?c=(\w+).*}, '/trajets/$1'
  r301 %r{/validation\.php\?c=(\w+).*}, '/trajets/$1/confirmer'
  r301 %r{/modification\.php\?m=(\w+).*}, '/trajets/$1/editer'
  r301 %r{/suppression\.php\?supp=(\w+).*}, '/trajets/$1/supprimer'

  r301 %r{/nouveau\.php\?c=(\w+)\&a\=r\&c2\=.+}, '/trajets/$1/creer_retour'
  r301 %r{/nouveau\.php\?c=(\w+)\&a\=d\&c2\=.+}, '/trajets/$1/dupliquer'

end