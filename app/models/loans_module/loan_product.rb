module LoansModule
  class LoanProduct < ApplicationRecord
    extend Totalable
    extend PastDuePercentage

    belongs_to :amortization_type,             class_name: "LoansModule::AmortizationType"
    belongs_to :loan_protection_plan_provider, class_name: "LoansModule::LoanProtectionPlanProvider", optional: true
    belongs_to :cooperative
    belongs_to :office,                        class_name: "Cooperatives::Office"
    belongs_to :interest_amortization,         class_name: "LoansModule::AmortizationConfigs::InterestAmortization"
    belongs_to :total_repayment_amortization,  class_name: "LoansModule::AmortizationConfigs::TotalRepaymentAmortization"
    has_many :interest_configs,                class_name: "LoansModule::LoanProducts::InterestConfig", dependent: :destroy
    has_many :penalty_configs,                 class_name: "LoansModule::LoanProducts::PenaltyConfig", dependent: :destroy
    has_many :loan_product_charges,            class_name: "LoansModule::LoanProducts::Charge", dependent: :destroy
    has_many :loans,                           class_name: "LoansModule::Loan", dependent: :nullify
    has_many :member_borrowers,                through: :loans, source: :borrower, source_type: "Member"
    has_many :employee_borrowers,              through: :loans, source: :borrower, source_type: "User"
    has_many :organization_borrowers,          through: :loans, source: :borrower, source_type: "Organization"
    has_many :interest_predeductions,          class_name: "LoansModule::LoanProducts::InterestPrededuction"
    has_many :loan_applications,               class_name: "LoansModule::LoanApplication"
    has_many :office_loan_products,            class_name: "Offices::OfficeLoanProduct"
    has_many :loan_aging_groups, through: :office_loan_products
    delegate :calculation_type, to: :amortization_type, prefix: true
    delegate :rate,
             :annual_rate,
             :calculation_type,
             :prededuction_type,
             :prededucted_rate,
             :amortization_type,
             :rate_type,
             :interest_revenue_account,
             :unearned_interest_income_account,
             :add_on?,
             to: :current_interest_config, prefix: true
    delegate :amortizer, :amortizeable_principal_calculator, to: :amortization_type
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
    delegate :calculation_type, to: :current_interest_prededuction, prefix: true
    validates :name, presence: true, uniqueness: true
    validates :maximum_loanable_amount, numericality: true

    delegate :calculation_type, :rate, :rate_in_percent, :number_of_payments, to: :current_interest_prededuction, prefix: true, allow_nil: true
    delegate :interest_amortizer, to: :interest_amortization
    delegate :total_repayment_amortizer, to: :total_repayment_amortization

    def self.active
      where(active: true)
    end

    def self.loan_payment_entries(args = {})
      accounts_with_revenue_accounts.credit_entries.not_cancelled.for_loans.entered_on(args)
    end

    def interest_charge_setter
      "LoansModule::InterestChargeSetters::#{current_interest_config_calculation_type.titleize.delete(' ')}".constantize
    end

    def payment_processor
      "LoansModule::PaymentProcessors::#{current_interest_config_calculation_type.titleize.delete(' ')}Interest".constantize
    end

    def interest_calculator
      if current_interest_config.prededucted?
        "LoansModule::InterestCalculators::#{current_interest_prededuction_calculation_type.titleize.delete(' ')}#{amortization_type.calculation_type.titleize.delete(' ')}".constantize
      elsif current_interest_config.add_on?
        "LoansModule::InterestCalculators::#{current_interest_config_calculation_type.titleize.delete(' ')}#{amortization_type.calculation_type.titleize.delete(' ')}".constantize
      end
    end

    def prededucted_interest_calculator
      if current_interest_config.prededucted?
        "LoansModule::PredeductedInterestCalculators::#{current_interest_prededuction_calculation_type.titleize.delete(' ')}#{amortization_type.calculation_type.titleize.delete(' ')}".constantize
      elsif current_interest_config.add_on?
        "LoansModule::PredeductedInterestCalculators::#{current_interest_config_calculation_type.titleize.delete(' ')}#{amortization_type.calculation_type.titleize.delete(' ')}".constantize
      end
    end

    def loan_processor
      if current_interest_config.prededucted?
        "LoansModule::LoanProcessors::#{current_interest_prededuction_calculation_type.titleize.delete(' ')}#{amortization_type.calculation_type.titleize.delete(' ')}".constantize
      elsif current_interest_config.add_on?
        "LoansModule::LoanProcessors::#{current_interest_config_calculation_type.titleize.delete(' ')}#{amortization_type.calculation_type.titleize.delete(' ')}".constantize
      end
    end

    def self.accounts
      accounts = []
      accounts << pluck(:current_account_id)
      accounts << pluck(:past_due_account_id)
      AccountingModule::Account.where(id: accounts.uniq.flatten)
    end

    def self.principal_accounts
      accounts
    end

    def self.current_accounts
      current_ids = pluck(:current_account_id)
      AccountingModule::Account.where(id: current_ids)
    end

    def self.past_due_accounts
      ids = pluck(:past_due_account_id)
      AccountingModule::Account.where(id: ids)
    end

    def self.interest_revenue_accounts
      ids = all.map { |a| a.current_interest_config.interest_revenue_account_id }
      AccountingModule::Account.where(id: ids)
    end

    # move
    def self.penalty_revenue_accounts
      ids = all.map { |a| a.current_penalty_config.penalty_revenue_account_id }
      AccountingModule::Account.where(id: ids)
    end

    def self.accounts_with_revenue_accounts
      ids = []
      ids << pluck(:current_account_id)
      ids << pluck(:past_due_account_id)
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
      entries = AccountingModule::Amount.where(account_id: loans.pluck(:receivable_account_id)).pluck(:entry_id)
      AccountingModule::Entry.where(id: entries)
    end

    def principal_accounts
      ids = []
      ids << current_account_id
      ids << past_due_account_id
      AccountingModule::Account.where(id: ids)
    end

    def self.loan_payments_total(args = {})
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
