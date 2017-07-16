# coding: utf-8
module ApplicationHelper

  def number_to_age(age)
    "#{age} ans".html_safe
  end

  def encode_decode(string)
    string.encode("iso-8859-1").force_encoding("utf-8") unless string.nil?
  end
  alias :ed :encode_decode

  def bootstrap_class_for(flash_type)
    { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning', notice: 'alert-info' }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    html = ''
    flash.each do |msg_type, message|
      html << content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
        content_tag(:button, 'x', class: 'close', data: { dismiss: 'alert' })
        message
      end
    end
    html.html_safe
  end

  def trip_steps_breadcrumb(trip, separator = '&rarr;')
    trip.points.map {|p| p.city }.join(" #{separator} ").html_safe
  end

  def trip_title(trip, separator = '&rarr;')
    "#{trip_steps_breadcrumb(trip, separator)} le #{l trip.departure_date, format: :long} à #{l trip.departure_time, format: :short}".html_safe
  end

  def trip_steps_breadcrumb_with_emphasis(trip, point_a_id = nil, point_b_id = nil, separator = '&rarr;')
    trip.points.map do |p|
      if p.id == point_a_id || p.id == point_b_id
        "<b>#{p.city}</b>"
      else
        p.city
      end
    end.join(" #{separator} ").html_safe
  end

  def trip_price(trip, point_a_price, point_b_price)
    return 0 if trip.price.nil?
    (point_b_price || trip.price) - (point_a_price || 0)
  end

  def admin_page?
    /admin/.match(params[:controller])
  end

  def back_trip_page?
    /new_for_back/.match(params[:action])
  end

  def trip_copy_page?
    /new_from_copy/.match(params[:action])
  end

end
