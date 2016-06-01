class Tool < ActiveRecord::Base
	belongs_to :company
	belongs_to :employee
	belongs_to :tools_card

	validates :name, presence: true, length: {maximum: 255}
	validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
	
end
