class Ingredient < ActiveRecord::Base
  attr_accessible :ingrediente, :quantit, :tipoquantit, :id, :recipe_id, :created_at, :updated_at

  belongs_to :recipe

# default_scope order: 'recipes.created_at DESC'

  default_scope order: 'ingredients.created_at DESC'

end