class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :name
      t.string :piatto
      t.string :cucina
      t.boolean :vegetariana
      t.boolean :vegana
      t.boolean :latticini
      t.boolean :glutine
      t.string :descrizione

      t.timestamps
    end
  end
end
