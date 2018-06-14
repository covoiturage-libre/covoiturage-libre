class DropUserAuthentications < ActiveRecord::Migration[5.1]
  def change
    drop_table :user_authentications
  end
end
