class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :ingrediente
      t.string :quantit
      t.string :tipoquantit
      t.integer :recipe_id

      t.timestamps
    end
  end
end