module CoopServicesModule
	class Program < ApplicationRecord
    enum payment_schedule_type: [:one_time_payment, :annually]
    belongs_to :account, class_name: "AccountingModule::Account"
		has_many :program_subscriptions, class_name: "MembershipsModule::ProgramSubscription"
    has_many :member_subscribers, through: :program_subscriptions, class_name: "Member"
    has_many :employee_subscribers, through: :program_subscriptions, class_name: "User"
    validates :name, presence: true, uniqueness: true
    validates :contribution, presence: true, numericality: true
    validates :account_id, presence: true
    def self.subscribers
      member_subscribers + employee_subscribers
    end
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
