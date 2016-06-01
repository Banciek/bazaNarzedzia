class CreateTools < ActiveRecord::Migration
  def change
    create_table :tools do |t|
      t.string :name
      t.integer :quantity
      t.boolean :has_card, default: false
      t.belongs_to :company, index: true

      t.timestamps null: false
    end
  end
end
