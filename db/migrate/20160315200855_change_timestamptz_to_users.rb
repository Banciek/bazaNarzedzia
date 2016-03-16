class ChangeTimestamptzToUsers < ActiveRecord::Migration
  def change
  	change_column :users, :created_at, :timestamptz, null: false
  	change_column :users, :updated_at, :timestamptz, null: false
  	change_column :users, :reset_sent_at, :timestamptz
  end
end
