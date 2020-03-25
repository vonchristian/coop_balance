 module MembershipsModule
	class ProgramSubscription < ApplicationRecord
    belongs_to :program_account,     class_name: 'AccountingModule::Account', foreign_key: 'account_id'
	  belongs_to :program,             class_name: 'Cooperatives::Program'
    belongs_to :office,              class_name: 'Cooperatives::Office'
	  belongs_to :subscriber,          polymorphic: true
	  has_many :subscription_payments, class_name: "AccountingModule::Entry", as: :commercial_document
    
    delegate :name,
             :amount,
             :description,
             :one_time_payment?,
             :annually?,
             :payment_status_finder,
             :date_setter,
             to: :program
             
    delegate :name, to: :subscriber, prefix: true

    def self.for_program(options={})
      where(program: options[:program])
    end

    #fix
	  def self.unpaid(options={})
      member_ids = Member.pluck(:id)
      account = args[:account]
      unpaid = account.amounts.where.not(commercial_document_id: member_ids)
      Member.where(id: unpaid)
    end
    def self.paid(options={})
      all.select{|a| a.paid?(options) }
    end

    def unpaid?(options={})
      !paid?(options)
    end

    def paid?(args={})
      payment_status_finder.new(program_subscription: self, date: args[:date]).paid?
    end 
	end
end
