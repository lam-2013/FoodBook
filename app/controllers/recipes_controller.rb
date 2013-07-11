class RecipesController < ApplicationController

  def home
    @recipes = Recipe.all
    @recipe_all = Recipe.first(8)
    if Recipe.find_by_user_id(current_user.id) == nil
    #l'utente non ha ricette

    #seleziona come ricetta consigliata una ricetta a caso
      key = 0
      while key == 0
        key = rand(Recipe.maximum('id'))
      end
      @advice = Recipe.find(key)

    #seleziona com cuoco consigliato un cuoco a caso che non sia l'utente corrente
      key = 0
      while key == 0 or key == current_user.id
        key = rand(User.maximum('id'))
      end
      @cook = User.find(key)

    else
  #l'utente ha già ricette

  #controlla quali ingredienti sono più presenti nelle ricette dell'utente e li ordina partendo da quello che compare più volte
      @advice = Ingredient.find_by_sql(["SELECT i.ingrediente, count(*)
FROM ingredients i, recipes r
WHERE i.recipe_id = r.id
AND r.user_id = "+current_user.id.to_s+"
GROUP BY i.ingrediente
ORDER BY count(*) DESC"])

      #seleziona un ingrediente a caso trai primi tre più presenti
      @advice = @advice[rand(max = 3)]

      #seleziona i cuochi (tranne se stesso) che hanno ricette con quell'ingrediente, ordinandoli partendo da chi ne ha di più
      @cook = Recipe.find_by_sql(["SELECT r.user_id, count(*)
FROM users u, recipes r, ingredients i
WHERE u.id = r.user_id
AND i.recipe_id = r.id
AND i.ingrediente = '"+@advice.ingrediente+"'
AND r.user_id <> "+current_user.id.to_s+"
GROUP BY u.id
ORDER BY count(*) DESC"])

      if @cook[0] == nil
      #non esistono cuochi che usano quell'ingrediente

        #consiglia un cuoco casuale
        @cook = User.find(current_user.id)
        while @cook.id == current_user.id
          key = 0
          while key == 0
            key = rand(User.maximum('id'))
          end
          @cook = User.find(key)
        end

      else
      #esistono cuochi che usano quell'ingrediente

      #ne seleziona uno a caso trai primi tre

        @cook = User.find(@cook[rand(3)].user_id)
      end

      #seleziona tutte le righe dove il nome dell'ingrediente è uguale a quello scelto prima
      @advice = Ingredient.find_all_by_ingrediente(@advice.ingrediente)

      if @advice[0] == nil
      #non esistono ingredienti con quel nome

        #ne sceglie uno a caso
        key = 0
        while key == 0
          key = rand(Recipe.maximum('id'))
        end
        @advice = Recipe.find(key)

      else
      #esistono elementi con quel nome

        #seleziona una ricetta casuale che contiene quell'ingrediente
        @temp = Recipe.find(@advice[rand(@advice.size)].recipe_id)

      #controlla che la ricetta non appartenga all'utente attuale
      #se dopo cento tentativi non trova una ricetta che soddisfi la condizione sopra esce dal ciclo while
        i = 0
        while @temp.user_id == current_user.id and i < 100
          @temp = Recipe.find(@advice[rand(@advice.size)].recipe_id)
          i += 1
        end

        if(@temp.user_id == current_user.id)
        #l'ultima ricetta trovata appartiene all'utente attuale

        #seleziona una ricetta casuale che non appartenga all'utente attuale
          while @temp.user_id == current_user.id
            key = 0
            while key == 0
              key = rand(Recipe.maximum('id'))
            end
            @temp = Recipe.find(key)
          end
        end

        #salva la ricetta uscita dal while o dall'if
        @advice = @temp
      end

    end

  end

  def show
  # get the recipe with id :id
    @recipe = Recipe.find(params[:id])
    @ingredient = Ingredient.find_all_by_recipe_id(params[:id])
  end

  def new

    @recipe = Recipe.new
    3.times {@recipe.ingredients.build}
  end

  def edit

    @recipe = Recipe.find(params[:id])

  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update_attributes(params[:recipe])
      flash[:success] = 'Ricetta modificata!'
      redirect_to :action => 'show', :id => @recipe
    else
      render 'edit'
    end
  end

  def destroy
# delete the user starting from her id
    Recipe.find(params[:id]).destroy
    flash[:success] = 'Ricetta cancellata!'
    redirect_to cookbook_path
  end

  #aggiungere ricetta di un altro al mio ricettario
  def add
  #trova la ricetta in base all'id
    @recipe = Recipe.find(params[:recipe_id])

  #trova gli ingredienti associati alla ricetta in ordine ascendente
    @ingredient = Ingredient.find_by_sql(["SELECT * FROM ingredients WHERE "+params[:recipe_id]+" = recipe_id ORDER BY ingredients.id ASC"])

  #cambia l'id della ricetta prendendo la prossima riga vuota
    @recipe.id = Recipe.maximum('id') + 1

  #cambia il nome della ricetta scrivendoci il nome del creatore
    @recipe.name = @recipe.name + ' (Ricetta di ' + User.find(@recipe.user_id).name + ')'

  #cambio il vecchio user id con quello attuale
    @recipe.user_id = current_user.id

  #faccio la stessa cosa per gli ingredienti
    count = 0
    3.times{@ingredient[count].id = Ingredient.maximum('id') + 1 + count
    @ingredient[count].recipe_id = @recipe.id
    @ingredient[count] = Ingredient.new(@ingredient[count].attributes)
    @ingredient[count].save
    count = count + 1}

  #inizializza la ricetta come nuova
    @recipe = Recipe.new(@recipe.attributes)
    @recipe.save

    redirect_to cookbook_path
  end

  def cookbook
    @recipes = Recipe.find_all_by_user_id(current_user)
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save

      flash[:success] = 'Ricetta registrata'

      redirect_to cookbook_path
    else
      render 'new'
    end

  end

  private
  def recipe_params
    params.require(:recipe).permit(:name,:piatto,:cucina, :vegetariana, :vegana, :latticini, :glutine, :descrizione, ingredients_attributes: [:id, :ingrediente, :quantit, :tipoquantit])
  end

  def search
    @search = Recipe.search(params[:search])

  end

end