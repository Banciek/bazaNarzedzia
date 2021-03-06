class UsersController < ApplicationController
  before_action :logged_in_user, only:[:show, :edit, :update, :destroy, :new, :create, :index]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_only, only: [:index, :new, :create]
  after_action :store_location, only: [:new, :show, :edit]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    #respond_to do |format|
      if @user.save
        @user.send_activation_email
        flash.now[:info] = 'Użytkownik utworzony, oczekuje na potwierdzenie adresu email.'
        render :new
       # format.json { render :show, status: :created, location: @user }
      else
        flash.now[:info] = 'Wystąpił błąd, prosimy spróbować ponownie.'
        render :new
       # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    #end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
   # respond_to do |format|
      if @user.update(user_params)
        flash[:success] = 'Dane użytkownika zostały poprawnie zapisane.'
        redirect_to @user 
     #   format.json { render :show, status: :ok, location: @user }
      else
        flash.now[:info] = 'Wystąpił błąd, prosimy spróbować ponownie.'
        render :edit
      #  format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    #end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    #respond_to do |format|
    redirect_to users_url
    flash[:info] = "Użytkownik #{@user.name} został poprawnie usunięty"
     # format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      current_user.id == params[:id].to_f ? @user = current_user : @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      set_user
      redirect_back_or(current_user) unless (current_user?(@user) || current_user.admin?)
    end

end
