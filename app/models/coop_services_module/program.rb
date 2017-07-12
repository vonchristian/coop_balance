module CoopServicesModule
	class Program < ApplicationRecord

		def self.subscribe_members_to_default_programs 
			all.default_program.each do |program|
				Member.all.each do |member| 
					member.program_subscriptions.find_or_create_by(program: program)
				end
			end 
		end 
		
		def self.default_program
			where(default_program: true)
		end
	end
end