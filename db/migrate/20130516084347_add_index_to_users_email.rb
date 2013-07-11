class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    # enforce email uniqueness
    add_index :users, :email, unique: true
  end
end
