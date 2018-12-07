module LoansModule
  class LoanApplication < ApplicationRecord
    monetize :loan_amount_cents, as: :loan_amount

    enum mode_of_payment: [:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :lumpsum]

    belongs_to :borrower, polymorphic: true
    belongs_to :preparer, class_name: "User", foreign_key: 'preparer_id'
    belongs_to :cooperative
    belongs_to :office, class_name: "CoopConfigurationsModule::Office"
    belongs_to :loan_product
    belongs_to :organization
    belongs_to :voucher, dependent: :destroy
    has_one    :loan, class_name: "LoansModule::Loan", dependent: :destroy
    has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", dependent: :destroy
    has_many :amount_adjustments, through: :voucher_amounts, dependent: :destroy, class_name: "Vouchers::AmountAdjustment"
    has_many :amortization_schedules, dependent: :destroy
    has_many :terms, as: :termable, dependent: :destroy
    has_many :amount_adjustments, class_name: "Vouchers::AmountAdjustment", dependent: :destroy

    delegate :name, to: :borrower, prefix: true
    delegate :name, :interest_revenue_account, :loans_receivable_current_account, to: :loan_product, prefix: true
    delegate  :monthly_interest_rate, to: :loan_product, prefix: true
    delegate :current_interest_config,  to: :loan_product
    delegate :avatar, :name, to: :borrower
    delegate :entry, to: :voucher, allow_nil: true
    delegate :rate, :straight_balance?, :annually?, :prededucted_number_of_payments, to: :current_interest_config, prefix: true

    validates :cooperative_id, presence: true
    def forwarded_loan? #check on amortization_schedule pdf
      false
    end
    def disbursement_date
      application_date
    end

    def maturity_date
      amortization_schedules.order(date: :asc).last.date
    end
    def current_term_number_of_months
      term
    end

    def reference_number
      self.voucher.try(:reference_number)
    end

    def principal_balance_for(schedule) #used to compute interest
      if schedule == self.amortization_schedules.order(date: :asc).first
        loan_amount.amount
      else
        loan_amount.amount - amortization_schedules.principal_for(schedule.previous_schedule(self), self)
      end
    end

    def term_is_within_one_year?
      (1..12).include?(term)
    end

    def term_is_within_two_years?
      (13..24).include?(term)
    end

    def term_is_within_three_years?
      (25..36).include?(term)
    end

    def term_is_within_four_years?
      (36..48).include?(term)
    end

    def term_is_within_five_years?
      (48..60).include?(term)
    end

    def principal_balance(args={})
      amortization_schedules.principal_balance(args)
    end

    def balance_for(schedule)
      loan_amount.amount - LoansModule::AmortizationSchedule.principal_for(schedule, self)
    end

    def voucher_amounts_excluding_loan_amount_and_net_proceed
      accounts = []
      accounts << cooperative.cash_accounts
      accounts << loan_product_loans_receivable_current_account
      voucher_amounts.excluding_account(account: accounts)
    end

    def total_interest
      current_interest_config.total_interest(self)
    end


    def interest_balance
      total_interest -
      voucher_interest_amount
    end

    def voucher_interest_amount
      voucher_amounts.for_account(account: current_interest_config.interest_revenue_account).total
    end

    def first_year_interest
      if term > 12
        multipliable_term = 12
      else
        multipliable_term = term
      end
      current_interest_config.interest_computation(principal_balance, multipliable_term)
    end

    def second_year_interest
      return 0 if term <= 12
      number = term - 12
      balance = principal_balance(number_of_months: number)
      current_interest_config.interest_computation(balance, number)
    end

    def third_year_interest
      return 0 if term <= 24
      number = term - 24
      balance = principal_balance(number_of_months: number)
      current_interest_config.interest_computation(balance, number)
    end

    def fourth_year_interest
      return 0 if term <= 36
      number = term - 36
      balance = principal_balance(number_of_months: number)
      current_interest_config.interest_computation(balance, number)
    end

    def fifth_year_interest
      return 0 if term <= 48
      number = term - 4
      balance = principal_balance(number_of_months: number)
      current_interest_config.interest_computation(balance, number)
    end

    def prededucted_interest
      current_interest_config.prededucted_interest(loan_amount, term)
    end


    def net_proceed
      loan_amount.amount - voucher_amounts.sum(&:adjusted_amount)
    end

    def total_charges
      accounts = []
      accounts << cooperative.cash_accounts
      accounts << loan_product_loans_receivable_current_account
      voucher_amounts.excluding_account(account: accounts).total
    end

    def disbursed?
      voucher && voucher.disbursed?
    end

    # def adjusted_interest_on_loan
    #   voucher_amounts.where(account: loan_product_interest_revenue_account).first.try(:adjusted_amount)
    # end

    def number_of_thousands # for Loan Protection fund computation
      loan_amount.amount / 1_000
    end
  end

end
