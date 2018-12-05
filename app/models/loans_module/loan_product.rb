module LoansModule
  class LoanProduct < ApplicationRecord
    extend Totalable
    belongs_to :loan_protection_plan_provider,    class_name: "LoansModule::LoanProtectionPlanProvider"
    belongs_to :cooperative
    belongs_to :loans_receivable_current_account,  class_name: "AccountingModule::Account"
    belongs_to :loans_receivable_past_due_account, class_name: "AccountingModule::Account"
    has_many :interest_configs,                    class_name: "LoansModule::LoanProducts::InterestConfig", dependent: :destroy
    has_many :penalty_configs,                     class_name: "LoansModule::LoanProducts::PenaltyConfig",dependent: :destroy
    has_many :loan_product_charges,                class_name: "LoansModule::LoanProducts::LoanProductCharge",dependent: :destroy
    has_many :loans,                               class_name: "LoansModule::Loan", dependent: :destroy
    has_many :member_borrowers,                    through: :loans, source: :borrower, source_type: 'Member'
    has_many :employee_borrowers,                  through: :loans, source: :borrower, source_type: 'User'
    has_many :organization_borrowers,              through: :loans, source: :borrower, source_type: 'Organization'

    delegate :rate, :annual_rate, to: :current_interest_config, prefix: true
    delegate :rate, to: :current_penalty_config, prefix: true, allow_nil: true

    delegate :interest_revenue_account,
             :interest_receivable_account,
             :unearned_interest_income_account,
             to: :current_interest_config
    delegate :penalty_receivable_account,
             :penalty_revenue_account,
             to: :current_penalty_config, allow_nil: true

    validates :name,:loans_receivable_current_account_id, :loans_receivable_past_due_account_id, presence: true

    validates :name, uniqueness: true
    validates :maximum_loanable_amount, numericality: true

    def self.accounts
      current_ids = all.pluck(:loans_receivable_current_account_id)
      past_due_ids = all.pluck(:loans_receivable_past_due_account_id)
      ids = current_ids + past_due_ids
      AccountingModule::Account.where(id: ids)
    end

    def self.past_due_accounts
      ids = all.pluck(:loans_receivable_past_due_account_id)
      AccountingModule::Account.where(id: ids)
    end

    def self.interest_revenue_accounts
      LoansModule::LoanProducts::InterestConfig.interest_revenue_accounts
    end


    def self.loan_payments(options={})
      accounts.debit_entries  +
      interest_revenue_accounts.debit_entries
    end


    def post_penalties #daily
      if !penalty_posted?
        PenaltyPosting.post
      end
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
      create_percent_based_charges(loan_application)
      create_amount_based_charges(loan_application)
      create_interest_on_loan_charge_for(loan_application)
      if loan_protection_plan_provider.present?
        create_loan_protection_fund(loan_application)
      end
    end

    def create_interest_on_loan_charge_for(loan_application)
      current_interest_config.create_charges_for(loan_application)
    end

    private
    def create_loan_protection_fund(loan_application)
        loan_application.voucher_amounts.create!(
        cooperative: loan_application.cooperative,
        commercial_document: loan_application,
        amount_type: 'credit',
        amount: LoanProtectionFund.compute_amount(loan_application),
        account: AccountingModule::Liability.find_by(name: 'Loan Protection Fund Payable'), # REFACTOR
        description: 'Loan Protection Fund'
        )
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
          cooperative: loan_application.cooperative,
          commercial_document: loan_application,
          description: charge.name,
          amount: charge.amount,
          amount_type: 'credit',
          account: charge.account
          )
      end
    end

    def create_charges_that_does_not_depends_on_loan_amount(loan_application)
     charges.not_depends_on_loan_amount.each do |charge|
        loan_application.voucher_amounts.create!(
          cooperative: loan_application.cooperative,
          commercial_document: loan_application,
          description:  charge.name,
          amount: charge.amount_for(loan_application),
          amount_type: 'credit',
          account: charge.account)
      end
    end
  end
end


#if interest is prededucted
