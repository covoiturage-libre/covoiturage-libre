namespace :cleanup do
  desc "TODO"
  task encoding: :environment do
    Trip.all.each do |trip|
      trip.name = trip.name.encode("iso-8859-1").force_encoding("utf-8")
      trip.description = trip.description.encode("iso-8859-1").force_encoding("utf-8") if trip.description.present?
      trip.points.each do |point|
        point.city = point.city.encode("iso-8859-1").force_encoding("utf-8")
        point.save!(validate: false)
      end
      trip.save!(validate: false)
    end
  end

  desc "TODO"
  task trips: :environment do
    Trip.destroy_all
  end

end
