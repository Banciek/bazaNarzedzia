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
  		  redirect_back_or user
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
  	flash[:info] = 'Zostałeś poprawnie wylogowany'
  end

  private

 

end
