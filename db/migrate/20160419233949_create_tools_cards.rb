class CreateToolsCards < ActiveRecord::Migration
  def change
    create_table :tools_cards do |t|
      t.belongs_to :employee, index: true, foreign_key: true

      t.timestamps null: false
    end
    change_column :tools_cards, :created_at, :timestamptz, null: false
  	change_column :tools_cards, :updated_at, :timestamptz, null: false
  end
end
