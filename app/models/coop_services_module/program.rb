module CoopServicesModule
	class Program < ApplicationRecord
    enum payment_schedule_type: [:one_time_payment, :annually, :monthly, :quarterly]

    belongs_to :account,             class_name: "AccountingModule::Account"
	  has_many :program_subscriptions, class_name: "MembershipsModule::ProgramSubscription"
    has_many :subscribers,           through: :program_subscriptions, source: :subscriber

    validates :name, presence: true, uniqueness: true
    validates :contribution, presence: true, numericality: true
    validates :account_id, presence: true

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
