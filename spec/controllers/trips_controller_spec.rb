require 'rails_helper'

describe TripsController, type: :controller do
  describe "POST #create" do

    it "should save new Trip with good time" do
      expect{
        post :create, trip: FactoryBot.attributes_for(:trip).except(:departure_time).merge(
          "departure_time(1i)" => "2018",
          "departure_time(2i)" => "1",
          "departure_time(3i)" => "30",
          "departure_time(4i)" => "16",
          "departure_time(5i)" => "10"
        )
      }.to change(Trip, :count).by(1)
      expect(response).to render_template :create
    end

    it "should render error when wrong time filled" do
      expect{
        post :create, trip: {
          "departure_time(1i)" => "2018",
          "departure_time(2i)" => "1",
          "departure_time(3i)" => "30",
          "departure_time(4i)" => "42",
          "departure_time(5i)" => "10"
        }
      }.not_to raise_error(ActiveRecord::MultiparameterAssignmentErrors)
      expect(response).to render_template :new
    end

  end
end
