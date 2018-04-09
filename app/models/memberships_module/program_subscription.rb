 module MembershipsModule
	class ProgramSubscription < ApplicationRecord
	  belongs_to :program,             class_name: "CoopServicesModule::Program"
	  belongs_to :subscriber,          polymorphic: true
	  has_many :subscription_payments, class_name: "AccountingModule::Entry", as: :commercial_document
	  delegate :name, :contribution, :account, :description, to: :program
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
        account.amounts.where(commercial_document: self.subscriber).entered_on(options).present? ||
        account.amounts.where(commercial_document: self).entered_on(options).present?
	  end
	end
end
