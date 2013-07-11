class AddRememberTokenToUsers < ActiveRecord::Migration
  def change          #la migrazione il token viene memorizzato in un cookie per mantenere attiva la sessione e finchè non fa logout rimane in memoria
    # add a remember token column for users
    add_column :users, :remember_token, :string
    # create the related index
    add_index :users, :remember_token
  end
end
