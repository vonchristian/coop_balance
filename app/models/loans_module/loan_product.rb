module LoansModule
  class LoanProduct < ApplicationRecord
    extend Totalable
    extend PastDuePercentage

    belongs_to :amortization_type,             class_name: "LoansModule::AmortizationType"
    belongs_to :loan_protection_plan_provider, class_name: "LoansModule::LoanProtectionPlanProvider"
    belongs_to :cooperative
    belongs_to :current_account,      class_name: "AccountingModule::Account"
    belongs_to :past_due_account,     class_name: "AccountingModule::Account"
    belongs_to :restructured_account, class_name: "AccountingModule::Account"

    has_many :interest_configs,                    class_name: "LoansModule::LoanProducts::InterestConfig", dependent: :destroy
    has_many :penalty_configs,                     class_name: "LoansModule::LoanProducts::PenaltyConfig",dependent: :destroy
    has_many :loan_product_charges,                class_name: "LoansModule::LoanProducts::LoanProductCharge",dependent: :destroy
    has_many :loans,                               class_name: "LoansModule::Loan", dependent: :nullify
    has_many :member_borrowers,                    through: :loans, source: :borrower, source_type: 'Member'
    has_many :employee_borrowers,                  through: :loans, source: :borrower, source_type: 'User'
    has_many :organization_borrowers,              through: :loans, source: :borrower, source_type: 'Organization'
    has_many :interest_predeductions,              class_name: "LoansModule::LoanProducts::InterestPrededuction"
    delegate :rate,
             :annual_rate,
             :calculation_type,
             :prededuction_type,
             :prededucted_rate,
             :amortization_type,
             :rate_type,
             :interest_revenue_account,
             to: :current_interest_config, prefix: true

    delegate :rate, :rate_in_percent, to: :current_penalty_config, prefix: true, allow_nil: true

    delegate :interest_revenue_account,
             :interest_receivable_account,
             :unearned_interest_income_account,
             :monthly_interest_rate,
             to: :current_interest_config

    delegate :penalty_receivable_account,
             :penalty_revenue_account,
             to: :current_penalty_config, allow_nil: true

    delegate :scheduler, to: :amortization_type, prefix: true

    validates :name,:current_account_id, :past_due_account_id, presence: true

    validates :name, uniqueness: true
    validates :maximum_loanable_amount, numericality: true

    delegate :calculation_type, :rate, :number_of_payments, to: :current_interest_prededuction, prefix: true

    def interest_calculator
      ("LoansModule::InterestCalculators::" + current_interest_prededuction_calculation_type.titleize.gsub(" ", "") + amortization_type.calculation_type.titleize.gsub(" ", "")).constantize
    end

    def prededucted_interest_calculator
      ("LoansModule::PredeductedInterestCalculators::" + current_interest_prededuction_calculation_type.titleize.gsub(" ", "") + amortization_type.calculation_type.titleize.gsub(" ", "")).constantize
    end

    def loan_processor
      ("LoansModule::LoanProcessors::" + current_interest_prededuction_calculation_type.titleize.gsub(" ", "") + amortization_type.calculation_type.titleize.gsub(" ", "")).constantize
    end

    def amortization_scheduler
      ("LoansModule::AmortizationSchedulers::" + current_interest_prededuction_calculation_type.titleize.gsub(" ", "") + amortization_type.calculation_type.titleize.gsub(" ", "")).constantize
    end

    def self.accounts
      accounts = []
      accounts << all.pluck(:current_account_id)
      accounts << all.pluck(:past_due_account_id)
      AccountingModule::Account.where(id: accounts.uniq.flatten)
    end

    def self.principal_accounts
      accounts
    end

    def self.current_accounts
      current_ids = all.pluck(:current_account_id)
      AccountingModule::Account.where(id: current_ids)
    end

    def self.past_due_accounts
      ids = all.pluck(:past_due_account_id)
      AccountingModule::Account.where(id: ids)
    end

    def self.interest_revenue_accounts #move
      LoansModule::LoanProducts::InterestConfig.interest_revenue_accounts
    end

    def self.penalty_revenue_accounts #move
      LoansModule::LoanProducts::PenaltyConfig.penalty_revenue_accounts
    end

    def self.accounts_with_revenue_accounts
      ids = []
      ids << all.pluck(:current_account_id)
      ids << all.pluck(:past_due_account_id)
      ids << LoansModule::LoanProducts::InterestConfig.interest_revenue_accounts.ids
      ids << LoansModule::LoanProducts::PenaltyConfig.penalty_revenue_accounts.ids
      AccountingModule::Account.where(id: ids.uniq.flatten)
    end

    def accounts_with_revenue_accounts
      ids = []
      ids << current_account_id
      ids << past_due_account_id
      ids << interest_revenue_account.id
      ids << penalty_revenue_account.id
      AccountingModule::Account.where(id: ids)
    end

    def entries
      loan_ids = loans.pluck(:id)
      entries = AccountingModule::Amount.where(commercial_document_id: loan_ids).pluck(:entry_id)
      AccountingModule::Entry.where(id: entries)
    end

    def principal_accounts
      ids = []
      ids << current_account_id
      ids << past_due_account_id
      AccountingModule::Account.where(id: ids)
    end


    def self.loan_payments(args={})
      accounts.credits_balance(args) +
      interest_revenue_accounts.credits_balance(args) +
      penalty_revenue_accounts.credits_balance(args)
    end


    def current_interest_config
      interest_configs.current
    end

    def current_penalty_config
      penalty_configs.current
    end

    def current_interest_prededuction
      interest_predeductions.current
    end
  end
end


#if interest is prededucted
