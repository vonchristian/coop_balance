module LoansModule
  class LoanProduct < ApplicationRecord
    extend Totalable
    extend PastDuePercentage
    #enum amortization_type: [:straight_line, :declining_balance]
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
             to: :current_interest_config, prefix: true

    delegate :rate, to: :current_penalty_config, prefix: true, allow_nil: true

    delegate :interest_revenue_account,
             :interest_receivable_account,
             :unearned_interest_income_account,
             to: :current_interest_config

    delegate :penalty_receivable_account,
             :penalty_revenue_account,
             to: :current_penalty_config, allow_nil: true

    validates :name,:current_account_id, :past_due_account_id, presence: true

    validates :name, uniqueness: true
    validates :maximum_loanable_amount, numericality: true

    delegate :calculation_type, :rate, :number_of_payments, to: :current_interest_prededuction, prefix: true

    def current_interest_prededuction
      interest_predeductions.current
    end

    def interest_amortization_calculator
      ("LoansModule::InterestCalculators::" + current_interest_prededuction_calculation_type.titleize.gsub(" ", "") + amortization_type.calculation_type.titleize.gsub(" ", "")).constantize
    end

    def self.accounts
      accounts = []
      accounts << all.pluck(:current_account_id)
      accounts << all.pluck(:due_account_id)
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

    def self.interest_revenue_accounts
      LoansModule::LoanProducts::InterestConfig.interest_revenue_accounts
    end

    def self.penalty_revenue_accounts
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

    def monthly_interest_rate
      interest_rate / 12.0
    end

    def interest_rate
      current_interest_config_rate
    end

    def penalty_rate
      current_penalty_config_rate
    end

    def create_charges_for(loan_application)
      create_interest_on_loan_charge_for(loan_application)
      create_percent_based_charges(loan_application)
      create_amount_based_charges(loan_application)
      if loan_protection_plan_provider.present?
        create_loan_protection_fund(loan_application)
      end
    end

    private

    def create_interest_on_loan_charge_for(loan_application)
      current_interest_config.create_charges_for(loan_application)
    end

    def create_loan_protection_fund(loan_application)
      loan_protection_plan_provider.create_charges_for(loan_application)
    end

    def create_percent_based_charges(loan_application)
      loan_product_charges.percent_based.each do |charge|
         loan_application.voucher_amounts.create!(
          cooperative: loan_application.cooperative,
          commercial_document: loan_application,
          description: charge.name,
          amount: charge.rate * loan_application.loan_amount.amount,
          amount_type: 'credit',
          account: charge.account
          )
      end
    end

    def create_amount_based_charges(loan_application)
      loan_product_charges.amount_based.each do |charge|
          loan_application.voucher_amounts.create!(
          cooperative:         loan_application.cooperative,
          commercial_document: loan_application,
          description:         charge.name,
          amount:              charge.amount,
          amount_type:         'credit',
          account:             charge.account
          )
      end
    end
  end
end


#if interest is prededucted
