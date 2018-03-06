module LoansModule
  class LoanProduct < ApplicationRecord
    belongs_to :loans_receivable_current_account, class_name: "AccountingModule::Account"
    belongs_to :loans_receivable_past_due_account, class_name: "AccountingModule::Account"

    has_many :interest_configs,      class_name: "LoansModule::LoanProducts::InterestConfig"
    has_many :penalty_configs,       class_name: "LoansModule::LoanProducts::PenaltyConfig"
    has_many :loan_product_charges,  class_name: "LoansModule::LoanProducts::LoanProductCharge"

    has_many :loans
    has_many :member_borrowers, through: :loans, source: :borrower, source_type: 'Member'
    has_many :employee_borrowers, through: :loans, source: :borrower, source_type: 'User'
    has_many :organization_borrowers, through: :loans, source: :borrower, source_type: 'Organization'
    has_many :charges, through: :loan_product_charges
#DO NOT ALLOW NIL RATE AND ACCOUNTS
    delegate :rate, to: :current_interest_config, prefix: true
    delegate :interest_revenue_account,
             :interest_receivable_account,
             :unearned_interest_income_account,
             :interest_rebate_account,
             to: :current_interest_config
    delegate :penalty_receivable_account,
             :penalty_revenue_account,
             to: :current_penalty_config

    validates :name,:loans_receivable_current_account_id, :loans_receivable_past_due_account_id, presence: true

    validates :name, uniqueness: true
    validates :maximum_loanable_amount, numericality: true

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

    def self.accounts
      all.map{|a| a.loans_receivable_current_account } +
      all.map{|a| a.interest_revenue_account } +
      all.map{ |a| a.penalty_receivable_account }
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
          loan.loan_charges.create!(chargeable: charge, commercial_document: loan)
      end
    end

    def create_charges_that_does_not_depends_on_loan_amount(loan)
     charges.not_depends_on_loan_amount.each do |charge|
        loan.loan_charges.find_or_create_by!(chargeable: charge, commercial_document: loan)
      end
    end
  end
end


#if interest is prededucted
