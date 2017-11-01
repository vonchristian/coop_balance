module LoansModule
  class LoanProtectionFund < ApplicationRecord
    belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :loan
    belongs_to :loan_protection_rate
  end
end
