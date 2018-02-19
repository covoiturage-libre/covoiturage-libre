class AddTermsOfServiceToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :terms_of_service, :boolean
  end
end
