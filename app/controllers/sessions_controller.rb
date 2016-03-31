class SessionsController < ApplicationController
  

  def new
  	redirect_to current_user if logged_in? 
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
      if user.activated?
  		  log_in(user)
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        flash[:success] = "Zalogowano poprawnie"
        current_user.admin? ? redirect_back_or(current_user) : redirect_back_or(current_user_companies.first)	  
      else
        flash[:warning] = "Konto nie aktywowane. Link aktywacyjny powinien znajować się w twojej skrzynce email."
        redirect_to root_url
      end
  	else
  		flash.now[:danger] = 'Błędny email lub hasło'
  		render 'new'
  	end
  end

  def destroy
  	log_out if logged_in?
  	redirect_to root_path
  	flash[:info] = 'Wylogowano poprawnie.'
  end

  #store_location version for ajax
  def update
    session[:forwarding_url] = request.url
  end

  private

 

end
