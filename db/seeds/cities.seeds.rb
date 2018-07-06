csv_text = File.read([Rails.root, 'db/data', 'cities.csv'].join('/'))
City.import_csv(csv_text)
