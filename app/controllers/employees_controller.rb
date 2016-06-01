class EmployeesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_only, only: [:show, :index]
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  #before_action :remove_cookie, only: [:destroy]


  # GET /employees
  # GET /employees.json
  def index
      @employees = Employee.all
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)
    @employee.company_id = session[:company_id] unless current_user.admin?

    rerender_data
    
    respond_to do |format|
      if @employee.save
        format.js { render "_save" }
    #   format.json { render :show, status: :created, location: @employee }
      else
        format.js { render :new }

        #format.html {flash.now[:warning] = "błąd"}
 #       format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to company_pulpit_path(@employee.company)
                     flash[:success] = 'Dane pracownika zostały zaktualizowane.' }
 #       format.json { render :show, status: :ok, location: @employee }
      else
        format.html {
          flash.now[:danger] = 'Błąd.'
          render :edit
          }
#        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    remove_cookie(params[:id])
    @employee.destroy
    rerender_data
    respond_to do |format| 
      format.js { render "_delete" } 
       
 #     format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:company_id, :first_name, :last_name, :work_as, :date_of_employment)
    end

    def users_employee?
      
      current_user_companies.each do |company|
        return true if company.id == @employee.company_id
      end
      return false
    end

    def correct_user
      
      redirect_back_or(current_user) unless (users_employee? || current_user.admin?)
    
    end

  def remove_cookie(id)
    temp = cookies[:expanded].split(/\s*,\s*/)
    #temp = temp - [@employee.id]
    #n = temp.length - 1
    t = ""
    (temp - [id]).each.with_index do |tmp,index|
      index == 0 ? t = "#{tmp}" : t = "#{t},#{tmp}"  
    end
    cookies.delete(:expanded)
    cookies[:expanded] = t

  end

end
