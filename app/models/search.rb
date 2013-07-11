class Search < ActiveRecord::Base
  attr_accessible :name, :piatto, :cucina, :vegetariana, :vegana, :latticini, :glutine, :descrizione


  def recipes
    @recipes ||= find_recipes
  end

  private

  def find_recipes
    recipes = Recipe.order(:name)
    recipes = recipes.where("name like ?", "%#{name}%") if name.present?
    recipes = recipes.where(piatto: piatto) if piatto.present?
    recipes = recipes.where(cucina: cucina) if cucina.present?
    recipes = recipes.where(vegetariana: vegetariana) if vegetariana.present?
    recipes = recipes.where(vegana: vegana) if vegana.present?
    recipes = recipes.where(latticini: latticini) if latticini.present?
    recipes = recipes.where(glutine: glutine) if glutine.present?
    recipes
  end
end
