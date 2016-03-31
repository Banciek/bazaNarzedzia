class DropUsersCompanies < ActiveRecord::Migration
  def change
  	drop_table :users_companies
  end
end
