 module MembershipsModule
	class ProgramSubscription < ApplicationRecord
    belongs_to :program_account, class_name: 'AccountingModule::Account', foreign_key: 'account_id'
	  belongs_to :program,             class_name: "Cooperatives::Program"
	  belongs_to :subscriber,          polymorphic: true
	  has_many :subscription_payments, class_name: "AccountingModule::Entry", as: :commercial_document
	  delegate :name,
             :amount,
             :account,
             :description,
             :one_time_payment?,
             :annually?,
             to: :program
    delegate :name, to: :subscriber, prefix: true

    def self.for_program(options={})
      where(program: options[:program])
    end


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
    #move to program
	  def paid?(options={})
      if one_time_payment?
        account.amounts.where(commercial_document: self).present?
      else
        account.amounts.entered_on(options).where(commercial_document: self.subscriber).present? ||
        account.amounts.entered_on(options).where(commercial_document: self).present? ||
        account.entries.entered_on(options).where(commercial_document: self).present? ||
        account.entries.entered_on(options).where(commercial_document: self.subscriber).present?
      end
	  end
	end
end
