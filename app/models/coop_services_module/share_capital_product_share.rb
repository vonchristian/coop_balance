module CoopServicesModule
	class ShareCapitalProductShare < ApplicationRecord
	  belongs_to :share_capital_product, class_name: "CoopServicesModule::ShareCapitalProduct"
	  def self.total_shares
	    sum(:share_count)
	  end
	end
end