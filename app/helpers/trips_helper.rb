module TripsHelper

  def display_steps(trip)
    breadcrumbs = ''
    trip.points.each_with_index do |step|
      breadcrumbs << step.city
      unless step == trip.points.last
        breadcrumbs << ' &rarr; '
      end
    end
    breadcrumbs.html_safe
  end

end
