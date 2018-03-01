require 'rails_helper'

describe TripsController, type: :controller do
  describe "POST #create" do

    before(:each) do
      @trip = FactoryBot.attributes_for(:trip)

      # Array of points in params
      @trip_points_params = Hash[@trip[:points].map { |point|
        [
          "points_attributes[#{SecureRandom.random_number(10_000_000)}]",
          point.attributes.slice(
            'kind',
            'rank', 'price',
            'lat', 'lon',
            'city'
          )
        ]
      }]
    end

    it "should save new Trip with good time" do
      trip_params = @trip.except(:departure_time, :points)
        .merge(@trip_points_params)
        .merge(
          "departure_time(1i)" => "2018",
          "departure_time(2i)" => "1",
          "departure_time(3i)" => "30",
          "departure_time(4i)" => "16",
          "departure_time(5i)" => "10",
        )

      expect(
        post :create, trip: trip_params
      ).to render_template :create
    end

    it "should render error when wrong time filled" do
      trip_params = @trip.except(:departure_time, :points)
        .merge(@trip_points_params)
        .merge(
          "departure_time(1i)" => "2018",
          "departure_time(2i)" => "1",
          "departure_time(3i)" => "30",
          "departure_time(4i)" => "42",
          "departure_time(5i)" => "10"
        )

      expect(
        post :create, trip: trip_params
      ).to render_template :new
    end

  end
end
