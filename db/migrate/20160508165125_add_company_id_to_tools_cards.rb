class AddCompanyIdToToolsCards < ActiveRecord::Migration
  def change
  	add_reference :tools_cards, :company, index: true, foreign_key: true, null: false
  end
end
