 module MembershipsModule
	class ProgramSubscription < ApplicationRecord
	  belongs_to :program, class_name: "CoopServicesModule::Program"
	  belongs_to :subscriber, polymorphic: true
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
    def unpaid?
      !paid?(from_date: Time.zone.now.beginning_of_year.beginning_of_day, to_date: Time.zone.now.end_of_year.end_of_day)
    end
	  def paid?(options={})
      account.amounts.where(commercial_document_id: self.subscriber_id).entered_on(options).present?
	  end
	end
end
