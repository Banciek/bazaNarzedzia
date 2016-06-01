class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer :company_id
      t.string :first_name
      t.string :last_name
      t.string :work_as
      t.timestamp :date_of_employment

      t.timestamps null: false
    end
  end
end
