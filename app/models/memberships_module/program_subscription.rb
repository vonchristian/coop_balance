 module MembershipsModule
	class ProgramSubscription < ApplicationRecord
	  belongs_to :program, class_name: "CoopServicesModule::Program"
	  belongs_to :subscriber, class_name: "Member", foreign_key: 'member_id'
	  has_many :subscription_payments, class_name: "AccountingModule::Entry", as: :commercial_document
	  delegate :name, :contribution, to: :program
	  
	  def paid?
	  	subscription_payments.program_subscription_payment.order(created_at: :asc).last.present? && entries.last.entry_date.between?(Time.zone.now.beginning_of_year, Time.zone.now.end_of_year)
	  end
	end
end