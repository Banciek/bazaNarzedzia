class CompaniesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit, :update, :destroy, :pulpit]
  before_action :admin_only, only:[:index]
  after_action :store_location, only: [:new, :show, :edit, :pulpit]

 
  def pulpit
    @employees = @company.employees.order(:last_name).includes(:tools_cards)
    @tools = @company.tools.order(:name)
    
    working_pulpit
  end



  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    @company.nip = nil if @company.nip == ''
    @company.regon = nil if @company.regon == ''

      
      if @company.save
        user_company = current_user.manages.build(company: @company) unless current_user.admin?
        if user_company.save
          session[:companies_ids].push(user_company.company_id) 
          flash[:success] = "Utworzono firmę."
          redirect_to @company
        end
      else
        flash.now[:danger] = "Wystąpił błąd, prosimy spróbować ponownie."
        render :new

      end

  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    #respond_to do |format|
      if @company.update(company_params)
        redirect_to @company 
        flash[:success] = 'Dane zostały poprawnie zaktualizowane.'
       # format.json { render :show, status: :ok, location: @company }
      else
       render :edit 
      #  format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    #end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    session[:companies_ids].delete(@company.id)
    @company.destroy
#    respond_to do |format|
    flash[:info] = "Firma wraz z pracownikami została poprawnie usunięta."
    redirect_to companies_url
 #     format.json { head :no_content }
#    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      company_id = params[:id].nil? ? params[:company_id].to_f : params[:id].to_f
      
      @not_exist = true
      current_user_companies.each do |company|
        if company.id == company_id
          @not_exist = false  
          @company = company
        end
      end

      @company = Company.find_by(id: company_id) if @not_exist
      session[:company_id] = company_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :full_name, :zip_code, :city, :street, :street_address, :nip, :regon)
    end

    def users_company?
      !@not_exist
    end

    def correct_user
      set_company
      redirect_back_or(current_user) unless (users_company? || current_user.admin?)
    end

end
