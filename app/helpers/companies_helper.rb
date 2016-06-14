module CompaniesHelper

#function for expanding employee info, based on cookies
  def expanded(eid)
    if cookies[:expanded]
      cookies[:expanded].split(/\s*,\s*/).each do |id|
        return 'in' if id.to_f == eid
      end
    end
  end

  #data needed for rerendering employees part
  def rerender_data
  	@company = Company.find_by(id: session[:company_id])
    @employees = @company.employees.order(:last_name).includes(:tools_cards)
    @tools = @company.tools.order(:name)
  end


  #function for finding tools employee when employee data is alreadey cached
  def tools_employee(tool)
    if !tool.employee_id.nil?
      @employees.each do |employee|
        return "#{employee.first_name} #{employee.last_name}" if tool.employee_id == employee.id
      end
    end
  end

  #check if tooltips are enabled
  def tooltips_enabled?
    cookies[:tooltips] ? false : true
  end

end
