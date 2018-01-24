module LoansModule
  class PredeductedInterest < ApplicationRecord
    belongs_to :loan
    belongs_to :credit_account, class_name: "AccountingModule::Account"
    belongs_to :debit_account, class_name: "AccountingModule::Account"

    validates :amount, :posting_date, presence: true
    validates :amount, numericality: true
  end
end
