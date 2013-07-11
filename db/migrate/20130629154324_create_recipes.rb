class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :piatto
      t.string :cucina
      t.boolean :vegetariana
      t.boolean :vegana
      t.boolean :latticini
      t.boolean :glutine
      t.string :descrizione
      t.integer :user_id

      t.timestamps
    end


  end
end
