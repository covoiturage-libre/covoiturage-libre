module Trips
  module Search
    extend ActiveSupport::Concern

    included do
      DEFAULT_SEARCH_AROUND_DISTANCE_IN_METERS = 25_000
      MAX_SEARCH_AROUND_DISTANCE_IN_METERS = 50_000
    end

    class_methods do

      def auto_around_distance(from_lon, from_lat, to_lon, to_lat)
        form_point = RGeo::Geographic.simple_mercator_factory.point(from_lat, from_lon)
        to_point = RGeo::Geographic.simple_mercator_factory.point(to_lat, to_lon)
        form_point.distance(to_point).to_f / 6
      end

      def from_to(from_lon, from_lat, to_lon, to_lat,
                  from_around_distance = DEFAULT_SEARCH_AROUND_DISTANCE_IN_METERS,
                  to_around_distance = DEFAULT_SEARCH_AROUND_DISTANCE_IN_METERS)
        around_distance = auto_around_distance(from_lon, from_lat, to_lon, to_lat)
        from_around_distance ||= around_distance
        from_around_distance = [
          from_around_distance || DEFAULT_SEARCH_AROUND_DISTANCE_IN_METERS,
          MAX_SEARCH_AROUND_DISTANCE_IN_METERS
        ].min
        to_around_distance ||= around_distance
        to_around_distance = [
          to_around_distance || DEFAULT_SEARCH_AROUND_DISTANCE_IN_METERS,
          MAX_SEARCH_AROUND_DISTANCE_IN_METERS
        ].min

        # Avoid Trips doublon
        matching_points = Point.select("DISTINCT ON (point_a.trip_id) point_a.*,
          point_a.id as point_a_id, point_a.price as point_a_price,
          point_b.id as point_b_id, point_b.price as point_b_price,

          (ST_Distance(
            ST_GeographyFromText('SRID=4326;POINT(' || point_a.lon || ' ' || point_a.lat || ')'),
            ST_GeographyFromText('SRID=4326;POINT(#{from_lon.to_f} #{from_lat.to_f})')
          ) + ST_Distance(
            ST_GeographyFromText('SRID=4326;POINT(' || point_b.lon || ' ' || point_b.lat || ')'),
            ST_GeographyFromText('SRID=4326;POINT(#{to_lon.to_f} #{to_lat.to_f})')
          )) AS point_ab_distance").
        from('points AS point_a').
        joins('INNER JOIN points AS point_b ON point_b.trip_id = point_a.trip_id').
        where("ST_Dwithin(
               ST_GeographyFromText('SRID=4326;POINT(' || point_a.lon || ' ' || point_a.lat || ')'),
               ST_GeographyFromText('SRID=4326;POINT(? ?)'),
               #{from_around_distance})", from_lon.to_f, from_lat.to_f).
        where("ST_Dwithin(
               ST_GeographyFromText('SRID=4326;POINT(' || point_b.lon || ' ' || point_b.lat || ')'),
               ST_GeographyFromText('SRID=4326;POINT(? ?)'),
               #{to_around_distance})", to_lon.to_f, to_lat.to_f).
        where('point_a.rank < point_b.rank').
        order('point_a.trip_id ASC, point_ab_distance ASC')

        select('trips.*,
          point_a_id, point_a_price,
          point_b_id, point_b_price,
          trips.id'). # trips.id is necessary here for the COUNT_COLUMN method used by Kaminari counting.
        joins("INNER JOIN (#{matching_points.to_sql}) AS point_a ON trips.id = point_a.trip_id")
      end

      def from_only(from_lon, from_lat, from_around_distance = DEFAULT_SEARCH_AROUND_DISTANCE_IN_METERS)
        from_around_distance = [
          from_around_distance || DEFAULT_SEARCH_AROUND_DISTANCE_IN_METERS,
          MAX_SEARCH_AROUND_DISTANCE_IN_METERS
        ].min

        # Avoid Trips doublon
        matching_points = Point.select("DISTINCT ON (point_a.trip_id) point_a.*,
          point_a.id AS point_a_id, point_a.price AS point_a_price,
          ST_Distance(
            ST_GeographyFromText('SRID=4326;POINT(' || point_a.lon || ' ' || point_a.lat || ')'),
            ST_GeographyFromText('SRID=4326;POINT(#{from_lon.to_f} #{from_lat.to_f})')
          ) AS point_a_distance")
        .from('points AS point_a')
        .where("ST_Dwithin(
          ST_GeographyFromText('SRID=4326;POINT(' || point_a.lon || ' ' || point_a.lat || ')'),
          ST_GeographyFromText('SRID=4326;POINT(? ?)'),
          #{from_around_distance}
        )", from_lon.to_f, from_lat.to_f)
        .where("point_a.kind <> 'To'")
        .order('point_a.trip_id ASC, point_a_distance ASC')

        select('trips.*,
          point_a_id, point_a_price, point_a_distance,
          trips.id'). # trips.id is necessary here for the COUNT_COLUMN method used by Kaminari counting.
        joins("INNER JOIN (#{matching_points.to_sql}) AS point_a ON trips.id = point_a.trip_id")
      end

      def to_only(to_lon, to_lat, to_around_distance = DEFAULT_SEARCH_AROUND_DISTANCE_IN_METERS)
        to_around_distance = [
          to_around_distance || DEFAULT_SEARCH_AROUND_DISTANCE_IN_METERS,
          MAX_SEARCH_AROUND_DISTANCE_IN_METERS
        ].min

        # Avoid Trips doublon
        matching_points = Point.select("DISTINCT ON (point_b.trip_id) point_b.*,
          point_b.id AS point_b_id, point_b.price AS point_b_price,
          ST_Distance(
            ST_GeographyFromText('SRID=4326;POINT(' || point_b.lon || ' ' || point_b.lat || ')'),
            ST_GeographyFromText('SRID=4326;POINT(#{to_lon.to_f} #{to_lat.to_f})')
          ) AS point_b_distance")
        .from('points AS point_b')
        .where("ST_Dwithin(
          ST_GeographyFromText('SRID=4326;POINT(' || point_b.lon || ' ' || point_b.lat || ')'),
          ST_GeographyFromText('SRID=4326;POINT(? ?)'),
          #{to_around_distance}
        )", to_lon.to_f, to_lat.to_f)
        .where("point_b.kind <> 'From'")
        .order('point_b.trip_id ASC, point_b_distance ASC')

        select('trips.*,
          point_b_id, point_b_price, point_b_distance,
          trips.id'). # trips.id is necessary here for the COUNT_COLUMN method used by Kaminari counting.
        joins("INNER JOIN (#{matching_points.to_sql}) AS point_b ON trips.id = point_b.trip_id")
      end

    end

  end
end
