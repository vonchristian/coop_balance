module WarehouseModule
	class WorkInProgressMaterial < ApplicationRecord
	  def self.total
	    sum(:quantity)
	  end
	end
end