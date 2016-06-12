class ToolsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_only, only: [:index, :show]
  before_action :set_tool, only: [:edit, :update, :destroy]
  before_action :can_assign?, only: [:assign, :withdraw, :pick]
  before_action :correct_user, only: [:edit, :update, :destroy, :assign, :withdraw, :pick]


  # GET /tools
  # GET /tools.json
  def index
    @tools = Tool.all
  end

  # GET /tools/1
  # GET /tools/1.json
  def show
  end

  # GET /tools/new
  def new
    @tool = Tool.new
  end

  # GET /tools/1/edit
  def edit
  end

  # POST /tools
  # POST /tools.json
  def create

    @tool = Tool.new(tool_params)
    @tool.company_id = session[:company_id] unless current_user.admin?
    rerender_data
    respond_to do |format|
      if @tool.save
        format.html { 
          flash.now[:success] = 'Narzędzie zostało poprawnie dodane.'
          redirect_to company_pulpit_path(@tool.company) 
           
        }
        format.js { render 'save'}
#        format.json { render :show, status: :created, location: @tool }
      else
#        format.html { render :new }
        format.js { render :new }
#       format.json { render json: @tool.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tools/1
  # PATCH/PUT /tools/1.json
  def update
    #current_tool = Tool.find(@tool.id)
    employee_id = params[:tool][:employee_id].to_i
    @tool.tools_card_id = nil if employee_id != @tool.employee_id

    respond_to do |format|
      
      if @tool.update(tool_params)
        format.html { 
          redirect_to company_pulpit_path(@tool.company) 
          flash[:success] = 'Dane narzędzia zostały poprawnie zaktualizowane.' }
        format.json { render :show, status: :ok, location: @tool }
      else
        format.html { 
          flash.now[:danger] = 'Błąd.'
          render :edit }
#        format.json { render json: @tool.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tools/1
  # DELETE /tools/1.json
  def destroy
    @tool.destroy
    rerender_data
    respond_to do |format|
      format.js { render 'delete' }

      format.html { 
        flash.now[:success] = 'Narzędzie zostało poprawnie usunięte.'
        redirect_to company_pulpit_path(@tool.company) 
      }
#      format.json { head :no_content }
    end
  end

  def assign
    params.permit(:tool_id, :employee_id, :tools_card_id)
    card_id = params[:tools_card_id]
    employee_id = params[:employee_id]
    #tool = Tool.find_by(id: params[:tool_id])
    if employee_id.blank?  
      if @tool.update_attributes(tools_card_id: card_id)
      
        rerender_data
        @message = 'Dodano narzędzie do karty.'
        render 'assign'

      end
    elsif @tool.update_attributes(tools_card_id: card_id, employee_id: employee_id)
      rerender_data
      @message = 'Przypisano poprawnie.'
      render 'assign2'
    end 
  end

  def withdraw
    params.permit(:tool_id)
    if @tool.update_attributes(tools_card_id: nil, employee_id: nil)
      rerender_data
      @message = 'Poprawnie odczepiono narzędzie.'
      render 'assign2'
    end
  end

  def pick
    params.permit(:tool_id)
    if @tool.update_attributes(tools_card_id: nil)
      rerender_data
      @message = 'Poprawnie odczepiono od karty.'
      render 'assign'
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tool
      @tool = Tool.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tool_params
      params.require(:tool).permit(:name, :quantity, :employee_id, :tools_card_id)
    end

    def users_tool?
      if !session[:companies_ids].is_a? Numeric
        session[:companies_ids].each do |id|
          return true if id == @tool.company_id
        end
      else
        return true if session[:companies_ids] == @tool.company_id
      end
      return false
    end

    def correct_user
      redirect_back_or(current_user) unless (users_tool? || current_user.admin?)
    end

    def can_assign?
      @tool = Tool.find_by(id: params[:tool_id])
    end

end
