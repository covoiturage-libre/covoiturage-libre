json.array! @results do |result|
  json.display_name result.data['address_components'][0]['short_name']
  json.lat result.data['geometry']['location']['lat']
  json.lon result.data['geometry']['location']['lng']
end