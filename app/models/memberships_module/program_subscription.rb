 module MembershipsModule
	class ProgramSubscription < ApplicationRecord
	  belongs_to :program,             class_name: "CoopServicesModule::Program"
	  belongs_to :subscriber,          polymorphic: true
	  has_many :subscription_payments, class_name: "AccountingModule::Entry", as: :commercial_document
	  delegate :name,
             :contribution,
             :account,
             :description,
             :one_time_payment?,
             :annually?,
             to: :program
    delegate :name, to: :subscriber, prefix: true
    def self.for(options={})
      where(program: options[:program])
    end
    def percent_type?
      false
    end

    def regular?
      false
    end
    def amount
      contribution
    end

	  def self.unpaid(options={})
      all.select{|a| a.unpaid?(options) }
    end
    def self.paid(options={})
      all.select{|a| a.paid?(options) }
    end

    def unpaid?(options={})
      !paid?(options)
    end

	  def paid?(options={})
      if one_time_payment?
        account.amounts.where(commercial_document: self.subscriber).present? ||
        account.amounts.where(commercial_document: self).present? ||
        account.entries.where(commercial_document: self).present? ||
        account.entries.where(commercial_document: self.subscriber).present?
      else
        account.amounts.entered_on(options).where(commercial_document: self.subscriber).present? ||
        account.amounts.entered_on(options).where(commercial_document: self).present? ||
        account.entries.entered_on(options).where(commercial_document: self).present? ||
        account.entries.entered_on(options).where(commercial_document: self.subscriber).present?
      end
	  end
	end
end
