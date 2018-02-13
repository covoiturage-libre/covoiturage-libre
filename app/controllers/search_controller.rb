# coding: utf-8
class SearchController < ApplicationController
  
  def index
    load_index_meta_data
    params.permit!
    params[:search] ||= {}

    @trips ||= []
    @search = Search.new(params[:search])
    the_number_of_trips_per_page = 10
    the_first_date = [(@search.date_value) -31, (Date.today) -31].min # we need trips of the past month to say "hey there was some trips last month" if no results
    the_last_date =  (@search.date_value) +31
    if @search.valid?
      if @search.from_lon.present? && @search.to_lon.present?
        the_trips_around_the_requested_day = Trip
                   .unscoped
                   .includes(:points)
                   .where('departure_date >= ?', the_first_date)
                   .where('departure_date <= ?', the_last_date)
                   .where(state: 'confirmed')
                   .from_to(@search.from_lon, @search.from_lat, @search.to_lon, @search.to_lat)
                   .order(departure_date: :asc)
                   .order(departure_time: :asc)
                   #.page(params[:page]).per(the_number_of_trips_per_page)
      elsif @search.from_lon.present?
        the_trips_around_the_requested_day = Trip
                   .unscoped
                   .includes(:points)
                   .where('departure_date >= ?', the_first_date)
                   .where('departure_date <= ?', the_last_date)
                   .where(state: 'confirmed')
                   .from_only(@search.from_lon, @search.from_lat)
                   .order(departure_date: :asc)
                   .order(departure_time: :asc)
                   #.page(params[:page]).per(the_number_of_trips_per_page)
      elsif @search.to_lon.present?
        the_trips_around_the_requested_day = Trip
                   .unscoped
                   .includes(:points)
                   .where('departure_date >= ?', the_first_date)
                   .where('departure_date <= ?', the_last_date)
                   .where(state: 'confirmed')
                   .to_only(@search.to_lon, @search.to_lat)
                   .order(departure_date: :asc)
                   .order(departure_time: :asc)
                   #.page(params[:page]).per(the_number_of_trips_per_page)
      end
    end
    # set .the_previous_trip__departure_date attribute
    if the_trips_around_the_requested_day.length >= 1
      the_trips_around_the_requested_day[0].the_previous_trip__departure_date = nil
    end
    if the_trips_around_the_requested_day.length >= 2
      for a_trip, a_previous_trip in the_trips_around_the_requested_day[1..-1].zip(the_trips_around_the_requested_day[0..-2])
        a_trip.the_previous_trip__departure_date = a_previous_trip.departure_date
      end
    end
    # trips of the selected day
    @the_trips_of_the_selected_day__all = the_trips_around_the_requested_day.select{ |a_trip| a_trip.departure_date == (@search.date_value) }
    @the_trips_of_the_selected_day__paginated = Kaminari.paginate_array(@the_trips_of_the_selected_day__all).page(params[:page]).per(the_number_of_trips_per_page)
    
    # trips of the past / trips of the future
    the_trips_of_the_past = the_trips_around_the_requested_day.select{ |a_trip| a_trip.departure_date < Date.today }
    the_trips_of_the_future = the_trips_around_the_requested_day.select{ |a_trip| a_trip.departure_date >= Date.today }
    
    # trips of the past month / trips of the previous month + trips of the following month ; (@search.date_value) is supposed to be >= Date.today ; TODO : remove the trips with 0 seat available
    @the_days_of_the_past_month = *(((Date.today) -31)..((Date.today) -1))
    @the_days_of_the_previous_and_the_following_months = *(([(Date.today), (@search.date_value) -8].max)..((@search.date_value) +8))
    
    @the_trips_of_the_past_month = the_trips_of_the_past.select{ |a_trip| a_trip.departure_date >= @the_days_of_the_past_month[0] and a_trip.departure_date <= @the_days_of_the_past_month[-1] }
    @the_trips_of_the_previous_and_the_following_months = the_trips_of_the_future.select{ |a_trip| a_trip.departure_date >= @the_days_of_the_previous_and_the_following_months[0] and a_trip.departure_date <= @the_days_of_the_previous_and_the_following_months[-1] }
    
    # trips of per day
    @the_trips__per_day = {}
    @the_days_of_the_previous_and_the_following_months.each do |a_day|
      the_trips_of_the_current_day = the_trips_around_the_requested_day.select{ |a_trip| a_trip.departure_date == a_day }
      @the_trips__per_day[a_day] = the_trips_of_the_current_day
    end
    # set of departure time rounded around the clock (13h10 -> 13h, 13h50 -> 13h) of trips of the previous month per day
    @the_departure_times__per_day = {}
    @the_trips__per_day.each do |a_day, some_trips|
      the_rounded_departure_times = some_trips.map{ |a_trip| a_trip.departure_time.round(60*60*60) }
      @the_departure_times__per_day[a_day] = the_rounded_departure_times.to_set
    end
  end
    
  private

    def search_params
      #params.require(:search).permit(:from_city, :from_lon, :from_lat, :to_city, :to_lon, :to_lat, :date)
    end

    def load_index_meta_data
      # meta data
      @meta[:title] = 'Covoiturage-libre.fr, rechercher une annonce de covoiturage'
      @meta[:description] = 'Recherchez une annonce de covoiturage parmis toutes les annonces sans frais et faites de la vraie économie du partage, covoiturez gratuitement et librement'
      #@meta[:description] << " de #{search_params[:from_city]}" if search_params[:from_city].present?
      #@meta[:description] << " à #{search_params[:to_city]}"    if search_params[:to_city].present?
      #@meta[:description] << " le #{search_params[:date]}"      if search_params[:date].present?
    end
end
