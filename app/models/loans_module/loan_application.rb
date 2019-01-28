module LoansModule
  class LoanApplication < ApplicationRecord
    monetize :loan_amount_cents, as: :loan_amount
    include PgSearch
    pg_search_scope :text_search, :associated_against => { :voucher => [:reference_number, :description] }

    enum mode_of_payment: [:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :lumpsum]

    belongs_to :borrower, polymorphic: true
    belongs_to :preparer, class_name: "User", foreign_key: 'preparer_id'
    belongs_to :cooperative
    belongs_to :office, class_name: "Cooperatives::Office"
    belongs_to :loan_product
    belongs_to :organization
    belongs_to :voucher, dependent: :destroy
    has_one    :loan, class_name: "LoansModule::Loan", dependent: :destroy
    has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", dependent: :destroy

    has_many :amortization_schedules, dependent: :destroy
    has_many :terms, as: :termable, dependent: :destroy

    delegate :name, :current_membership, :avatar, to: :borrower, prefix: true
    delegate :name, :interest_revenue_account, :current_account, to: :loan_product, prefix: true
    delegate :monthly_interest_rate,  to: :loan_product, prefix: true
    delegate :current_interest_config, :interest_calculator, :prededucted_interest_calculator, :amortizeable_principal_calculator,  to: :loan_product
    delegate :entry, to: :voucher, allow_nil: true
    delegate :rate, :straight_balance?, :annually?, :prededucted_number_of_payments, to: :current_interest_config, prefix: true
    validates :cooperative_id, presence: true

    def forwarded_loan? #check on amortization_schedule pdf
      false
    end
    def self.not_approved
      where(approved: false)
    end

    def self.not_cancelled
      where(cancelled: false)
    end

    def disbursement_date
      application_date
    end

    def maturity_date
      amortization_schedules.latest.date
    end

    def reference_number
      self.voucher.try(:reference_number)
    end

    def principal_balance_for(schedule) #used to compute interest
        balance = (loan_amount.amount - amortization_schedules.principal_for(schedule: schedule))
        if balance < 0
          0
        else
          balance
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


    def voucher_amounts_excluding_loan_amount_and_net_proceed
      accounts = []
      accounts << cooperative.cash_accounts
      accounts << loan_product_current_account
      voucher_amounts.excluding_account(account: accounts)
    end

    def total_interest
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


    def interest_balance
      if loan_product.current_interest_config.prededucted?
        total_interest -
        voucher_interest_amount
      elsif loan_product.current_interest_config.add_on?
        add_on_interest
      end

    end

    def voucher_interest_amount
      voucher_amounts.for_account(account: current_interest_config.interest_revenue_account).total
    end

    def first_year_interest
      if !current_interest_config.accrued?
        current_interest_config.compute_interest(first_year_principal_balance)
      else
        0
      end
    end

    def second_year_interest
      return 0 if !term_is_within_two_years?
      current_interest_config.compute_interest(second_year_principal_balance)
    end

    def third_year_interest
      return 0 if !term_is_within_three_years?
      current_interest_config.compute_interest(third_year_principal_balance)
    end

    def first_year_principal_balance
      loan_amount.amount
    end

    def second_year_principal_balance
      return 0 if !term_is_within_two_years?
      schedule = second_year_principal_balance_schedule_finder.new(loan_application: self).find_schedule
      principal_balance_for(schedule)
    end

    def third_year_principal_balance
      return 0 if !term_is_within_three_years?
      schedule = amortization_schedules.by_oldest_date[23]
      principal_balance_for(schedule)
    end

    def fourth_year_principal_balance
      return 0 if !term_is_within_four_years?
      schedule = amortization_schedules.by_oldest_date[35]
      principal_balance_for(schedule)
    end


    def prededucted_interest
      prededucted_interest_calculator.new(loan_application: self).prededucted_interest
    end

    def total_amortizeable_interest
      total_interest -
      prededucted_interest
    end

    def amortizeable_interest_for(schedule)
      principal_balance_for(schedule) * loan_product_monthly_interest_rate
    end


    def net_proceed
      loan_amount.amount - voucher_amounts.total
    end

    def total_charges
      accounts = []
      accounts << cooperative.cash_accounts
      accounts << loan_product_current_account
      voucher_amounts.excluding_account(account: accounts).total
    end

    def disbursed?
      voucher && voucher.disbursed?
    end

    def schedule_counter
      ("LoansModule::ScheduleCounters::" + mode_of_payment.titleize.gsub(" ", "") + "Counter").constantize
    end


    def amortization_date_setter
      ("LoansModule::AmortizationDateSetters::" + mode_of_payment.titleize.gsub(" ", "")).constantize
    end

    def second_year_principal_balance_schedule_finder
      ("LoansModule::ScheduleFinders::SecondYear::" + mode_of_payment.titleize.gsub(" ", "")).constantize
    end

    def first_amortization_date
      amortization_date_setter.new(date: application_date, term: term).start_date
    end

    def succeeding_amortization_date
      amortization_date_setter.new(date: amortization_schedules.latest.date).start_date
    end

    def schedule_count
      schedule_counter.new(loan_application: self).schedule_count
    end

    def amortizeable_principal(args={})
      amortizeable_principal_calculator.new(loan_application: self, schedule: args[:schedule]).amortizeable_principal
    end

    def number_of_thousands # for Loan Protection fund computation
      loan_amount.amount / 1_000.0
    end

    def add_on_interest
      current_interest_config.compute_interest(loan_amount.amount)
    end
  end
end
