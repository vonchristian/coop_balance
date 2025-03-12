module Cooperatives
  class Office < ApplicationRecord
    enum :office_type, {
      main_office: "main_office",
      branch_office: "branch_office",
      satellite_office: "satellite_office"
    }

    belongs_to :cooperative
    has_many :employees,                        class_name: "User"
    has_many :loans,                            class_name: "LoansModule::Loan"
    has_many :amortization_schedules,           class_name: "LoansModule::AmortizationSchedule"
    has_many :savings,                          class_name: "DepositsModule::Saving"
    has_many :time_deposits,                    class_name: "DepositsModule::TimeDeposit"
    has_many :share_capitals,                   class_name: "DepositsModule::ShareCapital"
    has_many :entries,                          class_name: "AccountingModule::Entry"
    has_many :bank_accounts,                    class_name: "BankAccount"
    has_many :loan_applications,                class_name: "LoansModule::LoanApplication"
    has_many :vouchers
    has_many :accounts,                         class_name: "AccountingModule::Account"
    has_many :office_saving_products,           class_name: "Offices::OfficeSavingProduct"
    has_many :saving_products,                  through: :office_saving_products, class_name: "SavingsModule::SavingProduct"
    has_many :office_share_capital_products,    class_name: "Offices::OfficeShareCapitalProduct"
    has_many :share_capital_products,           through: :office_share_capital_products, class_name: "Cooperatives::ShareCapitalProduct"
    has_many :office_loan_products,             class_name: "Offices::OfficeLoanProduct"
    has_many :loan_products,                    through: :office_loan_products, class_name: "LoansModule::LoanProduct"
    has_many :office_programs,                  class_name: "Offices::OfficeProgram"
    has_many :programs,                         through: :office_programs, class_name: "Cooperatives::Program"
    has_many :office_time_deposit_products,     class_name: "Offices::OfficeTimeDepositProduct"
    has_many :time_deposit_products,            through: :office_time_deposit_products, class_name: "CoopServicesModule::TimeDepositProduct"
    has_many :accounting_reports,               class_name: "AccountingModule::AccountingReport"
    has_many :loan_aging_groups,                class_name: "LoansModule::LoanAgingGroup"
    has_many :loan_agings,                      through: :loan_aging_groups, class_name: "LoansModule::Loans::LoanAging"
    has_many :office_loan_product_aging_groups, through: :office_loan_products, class_name: "LoansModule::OfficeLoanProductAgingGroup"
    has_many :memberships,                      class_name: "Cooperatives::Membership"
    has_many :member_memberships,               through: :memberships, source: :cooperator, source_type: "Member"
    has_many :time_deposit_applications,        class_name: "TimeDepositsModule::TimeDepositApplication"
    has_many :share_capital_applications,       class_name: "ShareCapitalsModule::ShareCapitalApplication"
    has_one :net_income_config,                 class_name: "Offices::NetIncomeConfig"
    has_many :office_ledgers, class_name: "Offices::Ledger"
    has_many :ledgers, through: :office_ledgers
    validates :name, uniqueness: true
    validates :name, :type, :contact_number, :address, presence: true

    delegate :net_surplus_account, :net_loss_account, :total_revenue_account, :total_expense_account, :interest_on_capital_account, to: :net_income_config

    delegate :cash_accounts, to: :employees
  end
end
