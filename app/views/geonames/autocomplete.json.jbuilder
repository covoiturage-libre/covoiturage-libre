json.array! @results do |result|
  json.city result.place_name + " (#{result.country_code} - #{result.postal_code})"
  json.lat result.latitude
  json.lon result.longitude
end