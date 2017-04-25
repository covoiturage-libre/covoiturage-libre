city_list = [
      [ 'Lyon', '69000', '69', 'xxx', 'fr', 45.759723, 4.842223, 1 ],
      [ 'Paris', '75000', '75', 'xxx', 'fr', 48.856578, 2.351828, 1 ],
      [ 'Angers', '49000', '49', 'xxx', 'fr', 47.47361, -0.55416, 1 ],
      [ 'Lille', '59000', '59', 'xxx', 'fr', 50.637222, 3.063333, 1 ],
      [ 'Toulouse', '31000', '31', 'xxx', 'fr', 43.604482, 1.443962, 1 ],
      [ 'Marseille', '13001', '13', 'xxx', 'fr', 43.296346, 5.369889, 1 ]
    ]

    city_list.each do |name, postal_code, department, region, country_code, \
        lat, lon, distance|
      City.create( name: name, postal_code: postal_code, \
        department: department, region: region, country_code: country_code, \
        lat: lat, lon: lon, distance: distance )
    end
