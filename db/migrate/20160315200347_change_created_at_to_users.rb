class ChangeCreatedAtToUsers < ActiveRecord::Migration
  def change
  	change_column :users, :activated_at, :timestamptz
  end
end
