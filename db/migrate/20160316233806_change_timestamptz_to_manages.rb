class ChangeTimestamptzToManages < ActiveRecord::Migration
  def change
  	change_column :manages, :created_at, :timestamptz, null: false
  	change_column :manages, :updated_at, :timestamptz, null: false
  end
end
