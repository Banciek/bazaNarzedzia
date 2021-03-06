class AccountActivationsController < ApplicationController

	def edit
		user = User.find_by(email: params[:email])
		if user && !user.activated? && user.authenticated?(:activation, params[:id])
			user.activate
			#log_in user
			flash[:success] = "Konto aktywowane!"
			redirect_to root_url
		elsif user.activated?
			flash[:info] = "Użytkownik został aktywowany wcześniej."
			redirect_to root_url
		else
			flash[:danger] = "Błędny link aktywacyjny."
			redirect_to root_url
		end
	end

end
