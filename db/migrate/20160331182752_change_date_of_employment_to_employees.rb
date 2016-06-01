class ChangeDateOfEmploymentToEmployees < ActiveRecord::Migration
  def change
  	change_column :employees, :date_of_employment, :date
  end
end
