class ChangeTimestamptzToEmployees < ActiveRecord::Migration
  def change
  	change_column :employees, :created_at, :timestamptz, null: false
  	change_column :employees, :updated_at, :timestamptz, null: false
  	change_column :employees, :date_of_employment, :timestamptz
  end
end
