module LoansModule
  class LoanProduct < ApplicationRecord
    belongs_to :loans_receivable_current_account, class_name: "AccountingModule::Account"
    belongs_to :loans_receivable_past_due_account, class_name: "AccountingModule::Account"

    has_many :interest_configs,      class_name: "LoansModule::LoanProducts::InterestConfig", dependent: :destroy
    has_many :penalty_configs,       class_name: "LoansModule::LoanProducts::PenaltyConfig",dependent: :destroy
    has_many :loan_product_charges,  class_name: "LoansModule::LoanProducts::LoanProductCharge",dependent: :destroy

    has_many :loans, dependent: :destroy
    has_many :member_borrowers, through: :loans, source: :borrower, source_type: 'Member'
    has_many :employee_borrowers, through: :loans, source: :borrower, source_type: 'User'
    has_many :organization_borrowers, through: :loans, source: :borrower, source_type: 'Organization'
    has_many :charges, through: :loan_product_charges
#DO NOT ALLOW NIL RATE AND ACCOUNTS
    delegate :rate, to: :current_interest_config, prefix: true
    delegate :rate, to: :current_penalty_config, prefix: true

    delegate :interest_revenue_account,
             :interest_receivable_account,
             :unearned_interest_income_account,
             to: :current_interest_config
    delegate :penalty_receivable_account,
             :penalty_revenue_account,
             to: :current_penalty_config

    validates :name,:loans_receivable_current_account_id, :loans_receivable_past_due_account_id, presence: true

    validates :name, uniqueness: true
    validates :maximum_loanable_amount, numericality: true
    def self.current_accounts
      ids = all.pluck(:loans_receivable_current_account_id)
      AccountingModule::Account.where(id: ids)
    end
    def self.total_balance(args={})
      accounts.balance(args)
    end
    def self.total_loan_releases(args={})
      current_accounts.debits_balance(args)
    end

    def self.total_loan_payments(args={})
      current_accounts.credits_balance(args)
    end

    def self.total_debits_balance(args={})
      accounts.debits_balance(args)
    end
    def self.total_credits_balance(args={})
      accounts.credits_balance(args)
    end

    def self.loan_payments(options={})
      entries = []
      self.all.each do |loan_product|
        loan_product.loans_receivable_current_account.credit_amounts.entered_on(options).recorded_by(options).each do |amount|
          entries << amount.entry
        end
        loan_product.interest_receivable_account.credit_amounts.entered_on(options).recorded_by(options).each do |amount|
          entries << amount.entry
        end
        loan_product.penalty_receivable_account.credit_amounts.entered_on(options).recorded_by(options).each do |amount|
          entries << amount.entry
        end
      end
      entries.uniq
    end


    def post_penalties #daily
      if !penalty_posted?
        PenaltyPosting
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

    def self.accounts
      accounts = self.all.pluck(:loans_receivable_current_account_id)
      AccountingModule::Account.where(id: accounts)
    end

    def self.loans_receivable_current_accounts
      all.map{|a| a.loans_receivable_current_account }
    end

    def borrowers
      member_borrowers + employee_borrowers + organization_borrowers
    end

    def create_charges_for(loan)
      create_charges_that_depends_on_loan_amount(loan)
      create_charges_that_does_not_depends_on_loan_amount(loan)
      create_interest_on_loan_charge_for(loan)
    end

    def create_interest_on_loan_charge_for(loan)
      current_interest_config.create_charges_for(loan)
    end

    def create_charges_that_depends_on_loan_amount(loan)
      charges.depends_on_loan_amount.includes_loan_amount(loan).each do |charge|
          loan.loan_charges.create!(
          charge: charge,
          commercial_document: loan,
          amount_type: 'credit'
          )
      end
    end

    def create_charges_that_does_not_depends_on_loan_amount(loan)
     charges.not_depends_on_loan_amount.each do |charge|
        loan.loan_charges.find_or_create_by!(
          charge: charge,
          commercial_document: loan,
          amount_type: 'credit')
      end
    end
  end
end


#if interest is prededucted
