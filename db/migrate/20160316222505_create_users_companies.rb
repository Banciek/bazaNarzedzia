class CreateUsersCompanies < ActiveRecord::Migration
  def change
    create_table :users_companies do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :company, index: true
    end
  end
end
