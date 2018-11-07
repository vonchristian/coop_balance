module LoansModule
  class LoanApplication < ApplicationRecord
    monetize :loan_amount_cents, as: "loan_amount"

    enum mode_of_payment: [:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :lumpsum]

    belongs_to :borrower, polymorphic: true
    belongs_to :preparer, class_name: "User", foreign_key: 'preparer_id'
    belongs_to :cooperative
    belongs_to :office, class_name: "CoopConfigurationsModule::Office"
    belongs_to :loan_product
    belongs_to :organization
    belongs_to :voucher
    has_many :voucher_amounts, as: :commercial_document, class_name: "Vouchers::VoucherAmount", dependent: :destroy
    has_many :amount_adjustments, through: :voucher_amounts, dependent: :destroy, class_name: "Vouchers::AmountAdjustment"
    has_many :amortization_schedules, dependent: :destroy
    has_many :terms, as: :termable, dependent: :destroy
    has_many :amount_adjustments, class_name: "Vouchers::AmountAdjustment", dependent: :destroy
    delegate :name, to: :borrower, prefix: true
    delegate :name, :interest_revenue_account, :loans_receivable_current_account, to: :loan_product, prefix: true
    delegate :current_interest_config, to: :loan_product
    delegate :avatar, :name, to: :borrower

    validates :cooperative_id, presence: true
    def current_term_number_of_months
      term
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

    def total_interest
      current_interest_config.total_interest(self)
    end

    def interest_balance
      current_interest_config.interest_balance(self)
    end

    def first_year_interest
      current_interest_config.first_year_interest(self)
    end

    def second_year_interest
      current_interest_config.second_year_interest(self)
    end

    def third_year_interest
      current_interest_config.third_year_interest(self)
    end

    def net_proceed
      loan_amount.amount - voucher_amounts.sum(&:adjusted_amount)
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

    def self.principal_balance_for(schedule) #used to compute interest
      if schedule == self.amortization_schedules.order(date: :asc).first
        loan_amount.amount
      else
        loan_amount.amount - amortization_schedules.principal_for(schedule.previous_schedule, self)
      end
    end

    def number_of_thousands # for Loan Protection fund computation
      loan_amount.amount / 1_000
    end
  end

end
