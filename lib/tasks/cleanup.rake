namespace :cleanup do

  desc "Set total price as last point price"
  task settopointprice: :environment do
    Trip.order(created_at: :desc).find_each do |trip|
      trip.point_to.update_attribute(:price, trip.price)
    end
  end

  desc "Try to fix encoding for old trips"
  task encoding: :environment do
    Trip.find_each do |trip|
      trip.name = trip.name.encode("iso-8859-1").force_encoding("utf-8")
      trip.description = trip.description.encode("iso-8859-1").force_encoding("utf-8") if trip.description.present?
      trip.points.each do |point|
        point.city = point.city.encode("iso-8859-1").force_encoding("utf-8")
        point.save!(validate: false)
      end

      trip.save!(validate: false)
    end
  end

  desc "fix missing lon and retrieve city encoding in points"
  task fixlon: :environment do
    Point.where(lon: nil).order(id: :desc).find_each do |point|
      city = City.where(postal_code: point.zipcode, country_code: point.country_iso_code).first
      if city.present?
        point.lon = city.lon
        point.city = city.name
        point.save(validate: false)
      end
    end

    Point.where("city like '%�%'").find_each do |point|
      city = City.where(postal_code: point.zipcode, country_code: point.country_iso_code).first
      if city.present?
        point.lon = city.lon
        point.city = city.name
        point.save(validate: false)
      end
    end
  end

end
