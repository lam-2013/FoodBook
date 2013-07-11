module SessionsHelper                #session_helper.rb 4 metodi

  # Perform the sign in by creating a permanent cookie (it lasts for 20 years...)
  # and by setting the current user
  #
  # user - The User to sign in
  def sign_in(user)      #1 permette di fare login mette il member token dell'utente e lo mette nel cookie
    cookies.permanent[:remember_token] = user.remember_token      #token è stato poi memorizzato, salvandolo in un cookie che scadrà 20 anni dopo la sua creazione
    # self is mandatory to tell Rails that current_user is a method already defined and not a variable to be created
    self.current_user = user # equivalent to: self.current_user=(user)         poi prende l'utente appena creato e lo mette come utente corrente.   self.current_user è un metodo che è definito li sotto.
  end

  # Set the user performing the sign in as the current user
  #
  # user - The User to be used as current user in the session
  def current_user=(user)
    @current_user = user
  end

  # Get the user corresponding to the remember token (taken from the permanent cookie)
  # only if the current_user instance variable is undefined
  def current_user  #sarebbe il getter in java. Se è nullo vado nel db  e lo prendo se non è nullo restituisce subito current_user.
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  # Check if the current user is signed in
  def signed_in?
    !current_user.nil?
  end

  # Perform the sign out of the current user, by clearing the current user instance variable
  # and deleting the corresponding cookie
  def sign_out   # In sign_out il current_user viene impostato come nullo
  self.current_user = nil
    cookies.delete(:remember_token)
  end

  # Check if the given user is also the current user (for authorization purposes)
  #
  # user - The User to check the authorization for
  def current_user?(user)
    user == current_user
  end

  # Redirect the visitor to the Sign in page if she is not logged in
  def signed_in_user
    redirect_to signin_url, notice: 'Please sign in' unless signed_in?
    # notice: 'Please sign in' is the same of flash[:notice] = 'Please sign in'
  end

end
