class AddKindToItineraries < ActiveRecord::Migration[5.0]
  def change
    add_column :itineraries, :kind, :string
  end
end
