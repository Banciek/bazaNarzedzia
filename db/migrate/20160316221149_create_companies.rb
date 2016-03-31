class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :full_name
      t.string :zip_code
      t.string :city
      t.string :street
      t.string :street_address
      t.string :nip
      t.string :regon

      t.timestamps null: false
    end
    add_index :companies, :nip, unique: true
    add_index :companies, :regon, unique: true
  end
end
