class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :trip, foreign_key: true
      t.string :sender_name
      t.string :sender_email
      t.text :body

      t.timestamps
    end
  end
end
