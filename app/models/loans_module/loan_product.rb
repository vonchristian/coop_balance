module LoansModule
  class LoanProduct < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged

    belongs_to :loans_receivable_current_account, class_name: "AccountingModule::Account"
    belongs_to :loans_receivable_past_due_account, class_name: "AccountingModule::Account"

    belongs_to :penalty_account, class_name: "AccountingModule::Account"

    has_one :interest_config, class_name: "LoansModule::InterestConfig"
    has_one :penalty_configuration

    has_many :loans
    has_many :member_borrowers, through: :loans, source: :borrower, source_type: 'Member'
    has_many :employee_borrowers, through: :loans, source: :borrower, source_type: 'User'
    has_many :organization_borrowers, through: :loans, source: :borrower, source_type: 'Organization'
    has_many :loan_product_charges
    has_many :charges, through: :loan_product_charges
#DO NOT ALLOW NIL RATE AND ACCOUNTS
    delegate :rate, to: :interest_config, prefix: true, allow_nil: true
    delegate :interest_revenue_account_id, to: :interest_config, allow_nil: true
    validates :name,:loans_receivable_current_account_id, :loans_receivable_past_due_account_id, presence: true

    validates :name, uniqueness: true
    validates :maximum_loanable_amount, numericality: true
    def interest_rate
      interest_config.rate
    end
    def self.accounts
      all.map{|a| a.account } +
      all.map{|a| a.interest_account } +
      all.map{ |a| a.penalty_account }
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
      interest_config.create_charges_for(loan)
    end

    def create_charges_that_depends_on_loan_amount(loan)
      charges.depends_on_loan_amount.includes_loan_amount(loan).each do |charge|
          loan.loan_charges.create(chargeable: charge)
      end
    end

    def create_charges_that_does_not_depends_on_loan_amount(loan)
     charges.not_depends_on_loan_amount.each do |charge|
        loan.loan_charges.find_or_create_by(chargeable: charge)
      end
    end
  end
end


#if interest is prededucted
