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

    def percent_type?
      false
    end

    def regular?
      false
    end
    def amount
      contribution
    end

	  def self.unpaid
      all.select{|a| a.unpaid? }
    end

    def unpaid?(options={})
      !paid?(options)
    end

	  def paid?(options={})
      if one_time_payment?
        account.amounts.where(commercial_document: self.subscriber).present? ||
        account.amounts.where(commercial_document: self).present?
      else
        account.amounts.where(commercial_document: self.subscriber).present? ||
        account.amounts.where(commercial_document: self).present?
      end
	  end
	end
end
