class CompaniesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_only, only:[:index]
  after_action :store_location, only: [:new, :show, :edit]

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

   # @company.attributes.drop(1).each do |a|
   #     @company[a.first] = nil if @company[a.first].blank?    
   # end

      company = @company
      if @company.save
        current_user.manages.create(company: company) unless current_user.admin?
        flash[:success] = "Utworzono firmę."
        redirect_to @company
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
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :full_name, :zip_code, :city, :street, :street_address, :nip, :regon)
    end

    def users_company?
      !current_user_companies.find_by(id: @company.id).nil?
    end

    def correct_user
      set_company
      redirect_back_or(current_user) unless (users_company? || current_user.admin?)
    end
end
