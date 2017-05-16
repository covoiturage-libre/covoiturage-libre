city_list = [
  ['Lyon', '69000', '69', 'Rhone', 'FR', 45.759723, 4.842223, 1],
  ['Paris', '75000', '75', 'Idf', 'FR', 48.856578, 2.351828, 1],
  ['Angers', '49000', '49', 'Maine', 'FR', 47.47361, -0.55416, 1],
  ['Lille', '59000', '59', 'Nord', 'FR', 50.637222, 3.063333, 1],
  ['Toulouse', '31000', '31', 'Sud-O', 'FR', 43.604482, 1.443962, 1],
  ['Marseille', '13001', '13', 'Provence', 'FR', 43.296346, 5.369889, 1]
]

city_list.each do |name, postal_code, department, region, country_code, lat, lon, distance|
  City.where(name: name, region: region).first_or_initialize.update(
    name: name, postal_code: postal_code, \
    department: department, region: region, \
    country_code: country_code, \
    lat: lat, lon: lon, distance: distance)
end
