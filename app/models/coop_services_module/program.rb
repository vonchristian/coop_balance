module CoopServicesModule
	class Program < ApplicationRecord
		has_many :program_subscriptions, class_name: "MembershipsModule::ProgramSubscription"
    has_many :subscribers, through: :program_subscribers, class_name: "Member"
    validates :name, presence: true, uniqueness: true

		def self.default_programs
			where(default_program: true)
		end

    def self.subscribe(member)
      default_programs.each do |program| 
        member.program_subscriptions.find_or_create_by(program: program)
      end 
    end 
    
		def self.subscribe_members(program) 
			return false if !program.default_program?
			Member.all.each do |member| 
				member.program_subscriptions.find_or_create_by(program: program)
			end
		end 
	end
end