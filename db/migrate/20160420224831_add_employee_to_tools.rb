class AddEmployeeToTools < ActiveRecord::Migration
  def change
    add_reference :tools, :employee, index: true, foreign_key: true
  end
end
