class ChangeTimestamptzToTools < ActiveRecord::Migration
  def change
  	change_column :tools, :created_at, :timestamptz, null: false
  	change_column :tools, :updated_at, :timestamptz, null: false
  end
end
