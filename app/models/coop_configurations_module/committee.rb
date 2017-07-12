module CoopConfigurationsModule
	class Committee < ApplicationRecord
		has_many :committee_members                                                                                           

		validates :name, presence: true, uniqueness: true
	end
end