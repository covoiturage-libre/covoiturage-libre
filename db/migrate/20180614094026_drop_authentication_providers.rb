class DropAuthenticationProviders < ActiveRecord::Migration[5.1]
  def change
    drop_table :authentication_providers
  end
end
