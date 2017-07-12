module CoopServicesModule
	class Program < ApplicationRecord
		has_many :subscribers, class_name: "MembershipsModule::ProgramSubscription"
    
    validates :name, presence: true, uniqueness: true
    after_commit :subscribe_members
		
		def self.default_programs
			where(default_program: true)
		end

		private 
		def subscribe_members 
			return false if !default_program?
			Member.all.each do |member| 
				member.program_subscriptions.find_or_create_by(program: program)
			end
		end 
	end
end