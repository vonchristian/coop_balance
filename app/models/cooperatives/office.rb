module Cooperatives
  class Office < ApplicationRecord
    belongs_to :cooperative
    has_many :loans,                   class_name: "LoansModule::Loan"
    has_many :savings,                 class_name: "MembershipsModule::Saving"
    has_many :time_deposits,           class_name: "MembershipsModule::TimeDeposit"
    has_many :share_capitals,          class_name: "MembershipsModule::ShareCapital"
    has_many :entries,                 class_name: "AccountingModule::Entry"
    has_many :bank_accounts,           class_name: "BankAccount"
    validates :name, presence: true, uniqueness: true
    validates :contact_number, presence: true
    validates :address, presence: true

  end
end
