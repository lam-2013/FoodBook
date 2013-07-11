class Recipe < ActiveRecord::Base
 attr_accessible :name, :piatto, :cucina, :vegetariana, :vegana, :latticini, :glutine, :descrizione, :ingredients_attributes, :id, :user_id, :created_at, :updated_at

  belongs_to :user

 has_many :ingredients, dependent: :destroy
  # default_scope order: 'recipes.created_at DESC'
  accepts_nested_attributes_for :ingredients
  validates :user_id, presence: true

  validates :name, presence: true
  validates :piatto, presence: true
  validates :cucina, presence: true

  validates :descrizione, presence: true
  default_scope order: 'recipes.created_at DESC'


  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end







end
