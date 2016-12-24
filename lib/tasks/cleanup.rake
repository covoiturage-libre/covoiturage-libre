namespace :cleanup do
  desc "TODO"
  task encoding: :environment do
    Trip.all.each do |trip|
      trip.name = trip.name.encode("utf-8", "iso-8859-1")
      trip.description = trip.name.encode("utf-8", "iso-8859-1")
      trip.points.each do |point|
        point.city = point.city.encode("utf-8", "iso-8859-1")
        point.save!(validate: false)
      end
      trip.save!(validate: false)
    end
  end

end
