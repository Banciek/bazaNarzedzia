class AddContentToToolsCards < ActiveRecord::Migration
  def change
  	add_column :tools_cards, :content, :text
  end
end
