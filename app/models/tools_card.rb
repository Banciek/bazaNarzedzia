class ToolsCard < ActiveRecord::Base
	#attr_accessor :content

  belongs_to :employee
  has_many :tools
  belongs_to :company

  before_destroy :unbound_tools

  def unbound_tools

    tools.each do |tool|
      tool.update_attribute(:tools_card_id, nil)
    end 
     
  end
end
