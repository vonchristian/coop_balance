module CoopServicesModule
	class Program < ApplicationRecord
    enum payment_schedule_type: [:one_time_payment, :annually, :monthly, :quarterly]
    belongs_to :cooperative
    belongs_to :account,             class_name: "AccountingModule::Account"
	  has_many :program_subscriptions, class_name: "MembershipsModule::ProgramSubscription", inverse_of: :program
    has_many :member_subscribers,    through: :program_subscriptions, source: :subscriber, source_type: "Member"
    has_many :employee_subscribers,  through: :program_subscriptions, source: :subscriber, source_type: "User"


    validates :name, presence: true, uniqueness: { scope: :cooperative_id }
    validates :contribution, presence: true, numericality: true
    validates :account_id, presence: true

    def subscribers
      employee_subscribers +
      member_subscribers
    end

    def self.default_programs
    	where(default_program: true)
    end

    def self.subscribe(subscriber)
      default_programs.each do |program|
        subscriber.program_subscriptions.find_or_create_by(program: program)
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
