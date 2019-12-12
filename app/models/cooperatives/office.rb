module Cooperatives
  class Office < ApplicationRecord
    belongs_to :cooperative
    has_many :employees, class_name: "User"
    has_many :loans,                        class_name: "LoansModule::Loan"
    has_many :amortization_schedules,       class_name: "LoansModule::AmortizationSchedule"
    has_many :savings,                      class_name: "MembershipsModule::Saving"
    has_many :time_deposits,                class_name: "MembershipsModule::TimeDeposit"
    has_many :share_capitals,               class_name: "MembershipsModule::ShareCapital"
    has_many :entries,                      class_name: "AccountingModule::Entry"
    has_many :bank_accounts,                class_name: "BankAccount"
    has_many :loan_applications,            class_name: "LoansModule::LoanApplication"
    has_many :vouchers
    has_many :accountable_accounts,         class_name: "AccountingModule::AccountableAccount", as: :accountable
    has_many :accounts,                     class_name: "AccountingModule::Account", through: :accountable_accounts
    has_many :office_saving_products,       class_name: 'Offices::OfficeSavingProduct'
    has_many :saving_products,              through: :office_saving_products, class_name: "CoopServicesModule::SavingProduct"
    has_many :share_capital_products,       class_name: "Cooperatives::ShareCapitalProduct"
    has_many :office_loan_products,         class_name: 'Offices::OfficeLoanProduct'
    has_many :loan_products,                through: :office_loan_products, class_name: "LoansModule::LoanProduct"
    has_many :office_programs,              class_name: 'Offices::OfficeProgram'
    has_many :programs,                     through: :office_programs, class_name: "Cooperatives::Program"
    has_many :accounting_reports,           class_name: "AccountingModule::AccountingReport"
    has_many :loan_aging_groups,            class_name: 'LoansModule::LoanAgingGroup'
    has_many :level_one_account_categories, class_name: 'AccountingModule::LevelOneAccountCategory'
    has_many :level_two_account_categories, class_name: 'AccountingModule::LevelTwoAccountCategory'
    has_many :level_three_account_categories, class_name: 'AccountingModule::LevelThreeAccountCategory'


    validates :name, uniqueness: true
    validates :name, :type, :contact_number, :address, presence: true

    def cash_accounts
      employees.cash_accounts
    end

    def normalized_type
      type.to_s.gsub("Cooperatives::Offices::", "")
    end

    def self.types
      ["Cooperatives::Offices::MainOffice",
       "Cooperatives::Offices::SatelliteOffice",
       "Cooperatives::Offices::BranchOffice"]
    end
  end
end
