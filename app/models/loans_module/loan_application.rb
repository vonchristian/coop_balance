module LoansModule
  class LoanApplication < ApplicationRecord
    enum mode_of_payment: [:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :lumpsum]

    belongs_to :borrower, polymorphic: true
    belongs_to :preparer
    belongs_to :cooperative
    belongs_to :loan_product
    has_many :voucher_amounts, as: :commercial_document, class_name: "Vouchers::VoucherAmount", dependent: :nullify
    has_many :amortization_schedules, dependent: :nullify
    has_many :terms, as: :termable
    has_many :amount_adjustments, class_name: "Vouchers::AmountAdjustment", dependent: :destroy
    delegate :name, to: :borrower, prefix: true
    delegate :interest_revenue_account, :loans_receivable_current_account, to: :loan_product, prefix: true
    delegate :current_interest_config, to: :loan_product
    delegate :avatar, :name, to: :borrower
    def principal_balance(args={})
      amortization_schedules.principal_balance(
          from_date: args[:from_date],
          to_date: args[:to_date])
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
      loan_amount - voucher_amounts.sum(&:adjusted_amount)
    end
    def disbursed?
      false
    end
    def annual_interest_rate
      loan_product.current_interest_config_rate
    end
    def adjusted_interest_on_loan
      voucher_amounts.where(account: loan_product_interest_revenue_account).first.try(:adjusted_amount)
    end


    def self.principal_balance_for(schedule) #used to compute interest
      if schedule == self.amortization_schedules.order(date: :asc).first
        loan_amount
      else
        loan_amount - amortization_schedules.principal_for(schedule.previous_schedule, self)
      end
    end
  end

end