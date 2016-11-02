class AddSenderPhoneToMessages < ActiveRecord::Migration[5.0]
  def change
    change_table :messages do |t|
      t.string :sender_phone
    end
  end
end
