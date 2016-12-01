Cms::Page.find_or_create_by(slug: 'association') do |page|
  page.name = 'L’association'
  page.title = 'L’association Covoiturage Libre'
  page.meta_desc = 'Présentation de l’association Covoiturage Libre'
end
Cms::Page.find_or_create_by(slug: 'presse') do |page|
  page.name = 'Presse'
  page.title = 'Presse'
  page.meta_desc = 'Revues de presse de l’association Covoiturage Libre'
end
Cms::Page.find_or_create_by(slug: 'faq') do |page|
  page.name = 'FAQ'
  page.title = 'F.A.Q'
  page.meta_desc = 'Questions fréquences sur le projet Covoiturage Libre'
end
Cms::Page.find_or_create_by(slug: 'cgus') do |page|
  page.name = 'CGUs'
  page.title = 'Conditions générales d’utilisation'
  page.meta_desc = 'Conditions générales d’utilisation du site Covoiturage Libre'
end
Cms::Page.find_or_create_by(slug: 'contact') do |page|
  page.name = 'Contact'
  page.title = 'Contact'
  page.meta_desc = 'Contactez l’associtation Covoiturage Libre'
end
Cms::Page.find_or_create_by(slug: 'mentions-legales') do |page|
  page.name = 'Mentions légales'
  page.title = 'Mentions légales'
  page.meta_desc = 'Mentions légales de l’associtation Covoiturage Libre'
end