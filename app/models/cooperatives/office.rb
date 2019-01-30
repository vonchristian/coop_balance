module Cooperatives
  class Office < ApplicationRecord
    belongs_to :cooperative
    has_many :employees, class_name: "User"
    has_many :loans,                   class_name: "LoansModule::Loan"
    has_many :amortization_schedules,  through: :loans, class_name: "LoansModule::AmortizationSchedule"
    has_many :savings,                 class_name: "MembershipsModule::Saving"
    has_many :time_deposits,           class_name: "MembershipsModule::TimeDeposit"
    has_many :share_capitals,          class_name: "MembershipsModule::ShareCapital"
    has_many :entries,                 class_name: "AccountingModule::Entry"
    has_many :bank_accounts,           class_name: "BankAccount"
    validates :name, presence: true, uniqueness: true
    validates :type, presence: true
    validates :contact_number, presence: true
    validates :address, presence: true

    def cash_accounts
      employees.cash_accounts
    end

    def normalized_type
      type.to_s.gsub("Cooperatives::Offices::", "")
    end
  end
end
