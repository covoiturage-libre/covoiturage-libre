# coding: utf-8
class SearchController < ApplicationController
  
  THE_NUMBER_OF_TRIPS_PER_PAGE = 10
  THE_NUMBER_OF_DAYS_IN_A_MONTH = 31
  THE_NUMBER_OF_DAYS_AROUND_THE_REQUESTED_DAY = 8

  def index
    load_index_meta_data

    @trips ||= []
    @search = Search.new(search_params)
    the_first_date = [(@search.date_value) -THE_NUMBER_OF_DAYS_IN_A_MONTH, (Date.today) -THE_NUMBER_OF_DAYS_IN_A_MONTH].min # we need trips of the past month to say "hey there was some trips last month" if no results
    the_last_date =  (@search.date_value) +THE_NUMBER_OF_DAYS_IN_A_MONTH

    if @search.valid?
      if @search.from_lon.present? && @search.to_lon.present?
        the_trips_around_the_requested_day = Trip
                   .unscoped
                   .includes(:points)
                   .where('departure_date >= ?', the_first_date)
                   .where('departure_date <= ?', the_last_date)
                   .where(state: 'confirmed')
                   .from_to(
                      @search.from_lon, @search.from_lat,
                      @search.to_lon, @search.to_lat,
                      @search.from_dist, @search.to_dist
                    )
                   .order(departure_date: :asc)
                   .order(departure_time: :asc)
                   #.page(params[:page]).per(THE_NUMBER_OF_TRIPS_PER_PAGE)
      elsif @search.from_lon.present?
        the_trips_around_the_requested_day = Trip
                   .unscoped
                   .includes(:points)
                   .where('departure_date >= ?', the_first_date)
                   .where('departure_date <= ?', the_last_date)
                   .where(state: 'confirmed')
                   .from_only(
                      @search.from_lon, @search.from_lat,
                      @search.from_dist
                    )
                   .order(departure_date: :asc)
                   .order(departure_time: :asc)
                   #.page(params[:page]).per(THE_NUMBER_OF_TRIPS_PER_PAGE)
      elsif @search.to_lon.present?
        the_trips_around_the_requested_day = Trip
                   .unscoped
                   .includes(:points)
                   .where('departure_date >= ?', the_first_date)
                   .where('departure_date <= ?', the_last_date)
                   .where(state: 'confirmed')
                   .to_only(
                      @search.to_lon, @search.to_lat,
                      @search.to_dist
                    )
                   .order(departure_date: :asc)
                   .order(departure_time: :asc)
                   #.page(params[:page]).per(THE_NUMBER_OF_TRIPS_PER_PAGE)
      end
    end

    set__the_previous_trip__departure_date__attribute(the_trips_around_the_requested_day)
    define_the_arrays_of_trips_of_the_selected_day(the_trips_around_the_requested_day)
    define_the_arrays_of_days_and_trips_of_the_past_month(the_trips_around_the_requested_day)
    define_the_arrays_of_days_and_trips_around_the_requested_day(the_trips_around_the_requested_day)
    define_the_trips_per_day_and_the_departure_times_per_day(the_trips_around_the_requested_day)
  end
  
  private
  
    def search_params
      params.permit!
      params[:search] || {}

      # params.require(:search).permit(
      #   :from_city, :from_lon, :from_lat, :from_dist,
      #   :to_city, :to_lon, :to_lat, :to_dist,
      #   :date
      # )
    end
    
    def load_index_meta_data
      # meta data
      @meta[:title] = "#{Rails.application.config.app_name}, rechercher une annonce de covoiturage"
      @meta[:description] = 'Recherchez une annonce de covoiturage parmis toutes les annonces sans frais et faites de la vraie économie du partage, covoiturez gratuitement et librement'
      #@meta[:description] << " de #{search_params[:from_city]}" if search_params[:from_city].present?
      #@meta[:description] << " à #{search_params[:to_city]}"    if search_params[:to_city].present?
      #@meta[:description] << " le #{search_params[:date]}"      if search_params[:date].present?
    end

    def set__the_previous_trip__departure_date__attribute(the_trips_ordered)
      # set .the_previous_trip__departure_date attribute
      if the_trips_ordered.length >= 1
        the_trips_ordered[0].the_previous_trip__departure_date = nil
      end
      if the_trips_ordered.length >= 2
        for a_trip, a_previous_trip in the_trips_ordered[1..-1].zip(the_trips_ordered[0..-2])
          a_trip.the_previous_trip__departure_date = a_previous_trip.departure_date
        end
      end
    end
    
    def define_the_arrays_of_trips_of_the_selected_day(the_trips_ordered)
      # 2 arrays of trips of the selected day (= @search.date_value), all and paginated
      @the_trips_of_the_selected_day__all = the_trips_ordered.select{ |a_trip| a_trip.departure_date == (@search.date_value) }
      @the_trips_of_the_selected_day__paginated = Kaminari.paginate_array(@the_trips_of_the_selected_day__all).page(params[:page]).per(THE_NUMBER_OF_TRIPS_PER_PAGE)
    end
    
    def define_the_arrays_of_days_and_trips_of_the_past_month(the_trips_ordered)
      # trips of the past month (Date.today -31 -> Date.today -1)
      the_trips_of_the_past = the_trips_ordered.select{ |a_trip| a_trip.departure_date < Date.today }
      @the_days_of_the_past_month = *(((Date.today) -THE_NUMBER_OF_DAYS_IN_A_MONTH)..((Date.today) -1))    
      @the_trips_of_the_past_month = the_trips_of_the_past.select{ |a_trip| a_trip.departure_date >= @the_days_of_the_past_month[0] and a_trip.departure_date <= @the_days_of_the_past_month[-1] }
    end

    def define_the_arrays_of_days_and_trips_around_the_requested_day(the_trips_ordered)
      # trips around (@search.date_value) (and >= Date.today) ; (@search.date_value) is supposed to be >= Date.today ; TODO : remove the trips with 0 seat available
      the_trips_of_the_future = the_trips_ordered.select{ |a_trip| a_trip.departure_date >= Date.today }
      @the_days_around_the_requested_day = *(([(Date.today), (@search.date_value) -THE_NUMBER_OF_DAYS_AROUND_THE_REQUESTED_DAY].max)..((@search.date_value) +THE_NUMBER_OF_DAYS_AROUND_THE_REQUESTED_DAY))
      @the_trips_around_the_requested_day = the_trips_of_the_future.select{ |a_trip| a_trip.departure_date >= @the_days_around_the_requested_day[0] and a_trip.departure_date <= @the_days_around_the_requested_day[-1] }
      @the_number_of_days_around_the_requested_day = THE_NUMBER_OF_DAYS_AROUND_THE_REQUESTED_DAY
    end
    
    def define_the_trips_per_day_and_the_departure_times_per_day(the_trips_ordered)
      # trips of per day, and departure times per day
      @the_trips__per_day = {}
      @the_days_around_the_requested_day.each do |a_day|
        the_trips_of_the_current_day = the_trips_ordered.select{ |a_trip| a_trip.departure_date == a_day }
        @the_trips__per_day[a_day] = the_trips_of_the_current_day
      end
      # set of departure time rounded around the clock (13h10 -> 13h, 13h50 -> 13h) of trips of the previous month per day
      @the_departure_times__per_day = {}
      @the_trips__per_day.each do |a_day, some_trips|
        the_rounded_departure_times = some_trips.map{ |a_trip| a_trip.departure_time.round(60*60*60) }
        @the_departure_times__per_day[a_day] = the_rounded_departure_times.to_set
      end
    end

end
