class ChangeTimestamptzToCompanies < ActiveRecord::Migration
  def change
  	change_column :companies, :created_at, :timestamptz, null: false
  	change_column :companies, :updated_at, :timestamptz, null: false
  end
end
