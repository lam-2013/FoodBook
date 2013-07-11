class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end

    # indexes
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # a user cannot follow another user more than one time...
    add_index :relationships, [ :follower_id, :followed_id ], unique: true
  end
end
