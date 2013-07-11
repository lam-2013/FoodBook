namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_relationships
    make_private_messages
    make_recipes
    make_ingredients
  end
end

def make_users
  admin = User.create!(name: "Claudia", #imposto chi è l'admin
                       surname: "Bertone",
                       email: "claudia@polito.it",
                       password: "claudia",
                       password_confirmation: "claudia",
                       age: "22")
  admin.toggle!(:admin) #toggle! method to flip the admin attribute from false to true. Così tutti gli altri che vengono creati non saranno admin

  99.times do |n| #per 99 volte crea falsi profili
    name = Faker::Name.last_name
    surname= Faker::Name.last_name
    # take users from the Rails Tutorial book since most of them have a "real" profile pic
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    age =rand(max=70)
    User.create!(name: name,
                 surname: surname,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 age: age)
  end
end


def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  # first user follows user 3 up to 51
  followed_users.each { |followed| user.follow!(followed) }
  # users 4 up to 41 follow back the first user
  followers.each { |follower| follower.follow!(user) }
end

def make_private_messages
  # generate 10 fake messages for the first user
  first_user = User.first
  users = User.all
  message_from_users = users[3..12]
  message_from_users.each do |user|
    msg_body = Faker::Lorem.sentence(8)
    msg_subject = Faker::Lorem.sentence(3)
    message = Message.new
    message.sender = user
    message.recipient = first_user
    message.subject = msg_subject
    message.body = msg_body
    message.save!
  end
end


def make_recipes
  @nomericetta = ["Pasta_al_forno", "Riso_ai_funghi", "Pasta_al_pesto", "Riso_alla_cantonese", "Panino_al_prosciutto", "Pollo_al_curry", "Pollo_al_latte", "Verdure_grigliate", "Parmigiana", "Tagliatelle_al_ragu", "Filetto_al_pepe_verde", "Fritto_misto_di_mare", "Pizza_margherita", "Tiramisu", "Cheese_cake", "Budino_ai_frutti_di_bosco", "Insalata_di_mare", "Insalata_di_Riso", "Maiale_in_agrodolce", "Fajitas_di_pollo", "Zucchine_ripiene", "Insalata_russa", "Pesce_spada_grigliato", "Sushi"]
  @piatto = ["antipasto", "primo", "secondo", "dolce", "altro"]
  @cucina = ["araba", "cinese", "italiana", "messica", "altro"]
  @vero = [true, false]

  users = User.all
  5.times do

    users.each { |user| user.recipes.create!(name: @nomericetta[rand(@nomericetta.size)],
                                             piatto: @piatto[rand(@piatto.size)], cucina: @cucina[rand(@cucina.size)],
                                             vegetariana: @vero[rand(@vero.size)], vegana: @vero[rand(@vero.size)],
                                             latticini: @vero[rand(@vero.size)], glutine: @vero[rand(@vero.size)],
                                             descrizione: Faker::Lorem.sentence(8)) }
  end
end

def make_ingredients
  @nomeingrediente = ["pasta", "finocchio", "carote", "cavolo", "Salmone", "Carciofi", "uova", "polenta", "zenzero", "pepe_verde", "acciughe", "trota", "carne_trita", "pasta_integrale", "spaghetti_di_soia", "germogli_di_soia", "salsa_di_soia", "pane", "petto_di_pollo", "maionese", "bresaola", "gorgonzola", "zucchero", "sale", "mortadella", "caramello", "prosciutto", "pollo", "riso", "calamaro", "fagioli", "sugo", "cipolla", "aglio", "pesto", "ceci", "manzo", "costine_di_maiale", "funghi"]
  @tipo = ["grammi", "numero"]
# generate 50 fake recipes for the first 10 users
  recipes = Recipe.all
  3.times do

    recipes.each { |recipe| recipe.ingredients.create!(ingrediente: @nomeingrediente[rand(@nomeingrediente.size)],
                                                       quantit: Random.rand(1...15), tipoquantit: @tipo[rand(@tipo.size)]) }

  end
end



