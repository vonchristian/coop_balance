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
    belongs_to :voucher
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
    def current_term_number_of_months
      term
    end

     def principal_balance_for(schedule) #used to compute interest
      if schedule == self.amortization_schedules.order(date: :asc).first
        loan_amount.amount
      else
        loan_amount.amount - amortization_schedules.principal_for(schedule.previous_schedule(self), self)
      end
    end

    def term_is_within_one_year?
      1.upto(12).include?(term)
    end
    def term_is_within_two_years?
      13.upto(24).include?(term)
    end
    def term_is_within_three_years?
      25.upto(36).include?(term)
    end

    def principal_balance(args={})
      amortization_schedules.principal_balance(
          from_date: args[:from_date],
          to_date: args[:to_date])
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
      if current_interest_config_annually?
        annually_total_interest
      elsif current_interest_config_straight_balance?
        straight_balance_total_interest
      end
    end

    def annually_total_interest
      if term_is_within_one_year?
        first_year_interest
      elsif term_is_within_two_years?
        first_year_interest +
        second_year_interest
      elsif term_is_within_three_years?
        first_year_interest +
        second_year_interest +
        third_year_interest
      end
    end


    def straight_balance_total_interest
      amortization_schedules.sum(&:interest)
    end

    def interest_balance
      total_interest.to_f -
      voucher_amounts.for_account(account: current_interest_config.interest_revenue_account).total
    end

    def first_year_interest
      (amortization_schedules.take(term).sum(&:principal) * current_interest_config_rate).to_f
    end

    def second_year_interest
      if term_is_within_two_years?
        (amortization_schedules.take(term - 12).sum(&:principal) * current_interest_config_rate).to_f
      else
        0
      end
    end

    def third_year_interest
      if term_is_within_three_years?
        (amortization_schedules.take(term - 24).sum(&:principal) * current_interest_config_rate).to_f
      else
        0
      end
    end


    def prededucted_interest
      if current_interest_config.percentage? && current_interest_config.prededucted_rate.present?
        (loan_amount.amount * current_interest_config.rate) * current_interest_config.prededucted_rate
      elsif current_interest_config.number_of_payment? && current_interest_config.prededucted_number_of_payments.present?
        amortization_schedules.order(date: :asc).first(current_interest_config.prededucted_number_of_payments).sum(&:interest)
      else
        0
      end
    end


    def net_proceed
      if entry.present?
        entry.total_cash_amount
      else
       loan_amount.amount - voucher_amounts.sum(&:adjusted_amount)
      end
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
    def annual_interest_rate
      loan_product.current_interest_config_rate
    end
    def adjusted_interest_on_loan
      voucher_amounts.where(account: loan_product_interest_revenue_account).first.try(:adjusted_amount)
    end

    def number_of_thousands # for Loan Protection fund computation
      loan_amount.amount / 1_000
    end
  end

end
