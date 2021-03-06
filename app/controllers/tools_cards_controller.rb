class ToolsCardsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_only, only: [:index, :edit]
  before_action :set_tools_card, only: [:show, :edit, :update, :destroy]
  before_action :correct_user?, only: [:show, :edit, :update, :destroy]


  # GET /tools_cards
  # GET /tools_cards.json
  def index
    @tools_cards = ToolsCard.all
  end

  # GET /tools_cards/1
  # GET /tools_cards/1.json
  def show
    
    @employee = @tools_card.employee
    
    current_user_companies.each do |company|
      @company = company if company.id == @tools_card.company_id  
    end
    
    @tools = @tools_card.tools
    # @tools_card.content = File.read Rails.root.join('app', 'views', 'tools_cards', '_pdf_content_message.html.haml')

    respond_to do |format|
      format.html {
        @tools_card.content = view_context.render 'pdf_content_message' if @tools_card.content.blank?
      }
      format.pdf do 
        pdf = ToolsCardsPdf.new(@tools_card, @employee, @company, @tools)
        send_data pdf.render, filename: "KN-#{@employee.first_name}#{@employee.last_name}-#{@tools_card.id}.pdf", type: 'application/pdf', disposition: "inline"
      end
    end

  end

  # GET /tools_cards/new
  def new
    @tools_card = ToolsCard.new(employee_id: params[:employee_id])
  end

  # GET /tools_cards/1/edit
  def edit
  end

  # POST /tools_cards
  # POST /tools_cards.json
  def create
    @tools_card = ToolsCard.new(tools_card_params)
    @tools_card.company_id = session[:company_id] 
    
    rerender_data
   
    respond_to do |format|
      if @tools_card.save
        #format.html { redirect_to @tools_card, notice: 'Tools card was successfully created.' }
        #format.json { render :show, status: :created, location: @tools_card }
        format.js { render 'saved' }
      else
        format.html { render :new }
        #format.json { render json: @tools_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tools_cards/1
  # PATCH/PUT /tools_cards/1.json
  def update
    params[:content] = nil if params[:content].blank?
    respond_to do |format|
      if @tools_card.update(tools_card_params)
        format.html { 
          redirect_to @tools_card
          flash[:success] = 'Zaktualizowano poprawnie.' 
        }
        format.json { render :show, status: :ok, location: @tools_card }
      else
        format.html { 
          redirect_to :back 
          flash[:danger] = 'Zbyt długa treść dokumentu.'
        }
        format.json { render json: @tools_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tools_cards/1
  # DELETE /tools_cards/1.json
  def destroy

    @tools_card.destroy
    rerender_data
    @message = 'Poprawnie usunięto kartę.'
    respond_to do |format|
      format.html { redirect_to tools_cards_url, notice: 'Tools card was successfully destroyed.' }
      format.json { head :no_content }
      format.js { render 'deleted' }
    end
  end

  def pick_on_show
    params.permit(:tool_id)
    id = params[:tool_id]

    @tool= Tool.find(id)
    #@tools_card = ToolsCard.find(params[:id])
    @tool.update_attributes(tools_card_id: nil)
      render nothing: true
    
    
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tools_card
      @tools_card = ToolsCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tools_card_params
      params.require(:tools_card).permit(:employee_id, :content)
    end

    def users_card?
      session[:companies_ids].each do |id|
        return true if id == @tools_card.company_id
      end
      return false
      
    end

    def correct_user?
      redirect_back_or(current_user) unless (users_card? || current_user.admin?)
    end

end
