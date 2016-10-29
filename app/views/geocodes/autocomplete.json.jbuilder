json.array! @results do |result|
  json.city result.data['address']['city'] + " (#{result.data['address']['postcode']})"
  json.lat result.data['lat']
  json.lon result.data['lon']
end