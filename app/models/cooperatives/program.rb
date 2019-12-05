module Cooperatives
	class Program < ApplicationRecord

    enum payment_schedule_type: [:one_time_payment, :annually, :monthly, :quarterly]

    belongs_to :cooperative
    belongs_to :level_one_account_category, class_name: 'AccountingModule::LevelOneAccountCategory'
    belongs_to :office,                 class_name: "Cooperatives::Office"
    belongs_to :account,                class_name: "AccountingModule::Account", optional: true
	  has_many :program_subscriptions,    class_name: "MembershipsModule::ProgramSubscription", inverse_of: :program
    has_many :member_subscribers,       through: :program_subscriptions, source: :subscriber, source_type: "Member"
    has_many :employee_subscribers,     through: :program_subscriptions, source: :subscriber, source_type: "User"
    has_many :organization_subscribers, through: :program_subscriptions, source: :subscriber, source_type: "Organization"
    has_many :programs,                 class_name: "Cooperatives::Program"
    validates :name, presence: true, uniqueness: { scope: :cooperative_id }
    validates :amount, presence: true, numericality: true
    
    def subscribers
      employee_subscribers +
      member_subscribers +
      organization_subscribers
    end

    def payment_status_finder
      ("Programs::PaymentStatusFinders::" + payment_schedule_type.titleize.gsub(" ", "")).constantize
    end

    def self.default_programs
    	where(default_program: true)
    end

    def paid?(args={})
      payment_status_finder.new(args.merge(program: self)).paid?
    end

    def subscribed?(subscriber)
      subscribers.include?(subscriber)
    end


    def self.subscribe(subscriber)
      default_programs.each do |program|
        subscriber.program_subscriptions.find_or_create_by!(program: program)
      end
    end
	end
end
