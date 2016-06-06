class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  
  def new
  end

  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
  	if @user
  		@user.create_reset_digest
  		@user.send_reset_email
  		flash[:info] = "Wiadomość z instukcją jak zresetować hasło została wysłana na podany email."
  		redirect_to root_url
  	else
  		flash.now[:danger] = 'Użytkownik z podanym adresem email nie istnieje'
  		render :new
  	end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user && @user.authenticated?(:reset, params[:id]) && !@user.password_reset_expired?
      @user.update_attributes(user_params, reset_digest: nil)
      #log_in @user
      flash[:success] = "Hasło zostało zresetowane"
      redirect_to root_url
    elsif @user.password_reset_expired?
      flash.now[:danger] = 'Link reetujący hasło jest za stary. Wygeneruj nowy.'
      render 'edit'
    else
      flash.now[:danger] = 'Błędny link'
      render 'edit'
    end
      
  end

  private

  def user_params
      params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email].downcase)
  end

  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      flash[:warning] = "Błędny link"
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Link do zresetowania hasła wygasł." + "Wygeneruj nowy"
      redirect_to new_password_reset_url
    end
  end

end
