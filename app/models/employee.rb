class Employee < ActiveRecord::Base
	belongs_to :company
	has_many :tools_cards, dependent: :destroy
	has_many :tools

	before_destroy :unbound_tools

	validates :first_name, length: {maximum: 255}, presence: true
	validates :last_name, length: {maximum: 255}, presence: true
	validates :work_as, length: {maximum: 255}
	VALID_DATE_REGEX = /\A\d{4}[-][0-1]\d[-][0-3]\d\z/i
	validates :date_of_employment, length: {is: 10}, format: {with: VALID_DATE_REGEX}, allow_blank: true 


  def unbound_tools

    tools.each do |tool|
      tool.update_attribute(:employee_id, nil)
    end 
     
  end
end
