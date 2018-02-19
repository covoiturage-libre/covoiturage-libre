json.array! @results do |result|
  json.city result.place_name
  json.postcode result.postal_code
  json.country I18n.t('country.'+result.country_code)
  json.lat result.latitude
  json.lon result.longitude
end