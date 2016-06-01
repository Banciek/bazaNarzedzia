class AddToolsToToolsCard < ActiveRecord::Migration
  def change
  	add_reference :tools, :tools_card, index: true, foreign_key: true
  end
end
