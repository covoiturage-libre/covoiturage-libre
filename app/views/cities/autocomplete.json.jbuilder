json.array! @results do |result|
  json.city result.name
  json.postcode result.postal_code
  json.country I18n.t('country.'+result.country_code)
  json.lat result.lat
  json.lon result.lon
end