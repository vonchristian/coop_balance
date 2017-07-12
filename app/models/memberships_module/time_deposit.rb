module MembershipsModule
  class TimeDeposit < ApplicationRecord
    belongs_to :depositor, class_name: "Member", foreign_key: 'member_id'
    belongs_to :time_deposit_product, class_name: "CoopServicesModule::TimeDepositProduct"
    has_many :deposits, class_name: "AccountingModule::Entry", as: :commercial_document

    delegate :name, to: :time_deposit_product, allow_nil: true, prefix: true
    def balance
     deposits.time_deposit.map{|a| a.debit_amounts.sum(:amount) }.sum
    end
  end
end