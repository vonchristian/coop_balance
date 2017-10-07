 module MembershipsModule
	class ProgramSubscription < ApplicationRecord
	  belongs_to :program, class_name: "CoopServicesModule::Program"
	  belongs_to :subscriber, class_name: "Member", foreign_key: 'member_id'
	  has_many :subscription_payments, class_name: "AccountingModule::Entry", as: :commercial_document
	  delegate :name, :contribution, :description, to: :program
	  def self.unpaid
      all.select{|a| a.unpaid? }
    end
    def unpaid?
      !paid?(from_date=Time.zone.now.beginning_of_year.beginning_of_day, to_date= Time.zone.now.end_of_year.end_of_day)
    end
	  def paid?(from_date, to_date)
      entry = subscription_payments.program_subscription_payment.order(created_at: :asc).last
      entry.present? && entry.entry_date.between?(from_date, to_date)
	  end
	end
end