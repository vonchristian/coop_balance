module LoansModule
  class LoanApplication < ApplicationRecord
    monetize :loan_amount_cents, as: :loan_amount
    include PgSearch::Model
    pg_search_scope :text_search, associated_against: { voucher: %i[reference_number description] }

    enum mode_of_payment: { daily: 0, weekly: 1, monthly: 2, semi_monthly: 3, quarterly: 4, semi_annually: 5, lumpsum: 6 }

    belongs_to :cart,                     class_name: 'StoreFrontModule::Cart'
    belongs_to :borrower,                 polymorphic: true
    belongs_to :preparer,                 class_name: 'User'
    belongs_to :cooperative
    belongs_to :office, class_name: 'Cooperatives::Office'
    belongs_to :loan_product
    belongs_to :organization,             optional: true
    belongs_to :receivable_account,       class_name: 'AccountingModule::Account', dependent: :destroy
    belongs_to :interest_revenue_account, class_name: 'AccountingModule::Account', dependent: :destroy
    belongs_to :voucher,                  dependent: :destroy, optional: true
    has_one    :loan,                     class_name: 'LoansModule::Loan', dependent: :nullify
    has_many :amortization_schedules,     dependent: :destroy
    has_many :terms, as: :termable,       dependent: :destroy

    has_many_attached :supporting_documents

    delegate :name, :current_membership, :avatar, to: :borrower, prefix: true
    delegate :name, to: :loan_product, prefix: true
    delegate :monthly_interest_rate, to: :loan_product, prefix: true
    delegate :current_interest_config, :interest_calculator, :prededucted_interest_calculator, :amortizeable_principal_calculator, :amortization_type, to: :loan_product
    delegate :entry, to: :voucher, allow_nil: true
    delegate :reference_number, to: :voucher, prefix: true, allow_nil: true
    delegate :rate, :straight_balance?, :annually?, :prededucted_number_of_payments, to: :current_interest_config, prefix: true

    validates :account_number, presence: true, uniqueness: true

    validates :number_of_days, presence: true, numericality: { only_integer: true }

    def voucher_amounts
      if cart.present?
        cart.voucher_amounts
      else
        voucher.voucher_amounts
      end
    end

    # check on amortization_schedule pdf
    def forwarded_loan?
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
      voucher.try(:reference_number)
    end

    # sorting ascending_order
    def ascending_order
      if voucher.blank?
        0
      else
        voucher.reference_number.to_i
      end
    end

    # used to compute interest
    def principal_balance_for(schedule)
      principal_amount = amortization_schedules.principal_for(schedule: schedule)
      balance          = (loan_amount.amount - principal_amount)

      [balance, 0].max
    end

    def term_is_within_one_year?
      (1..365).cover?(number_of_days)
    end

    def term_is_within_two_years?
      (366..730).cover?(number_of_days)
    end

    def term_is_within_three_years?
      (731..1095).cover?(number_of_days)
    end

    def term_is_within_four_years?
      (1096..1460).cover?(number_of_days)
    end

    def term_is_within_five_years?
      (1461..1825).cover?(number_of_days)
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
      elsif term_is_within_four_years?
        first_year_interest +
          second_year_interest +
          third_year_interest +
          fourth_year_interest
      elsif term_is_within_five_years?
        first_year_interest +
          second_year_interest +
          third_year_interest +
          fourth_year_interest +
          fifth_year_interest
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
      if cart.present?
        cart.voucher_amounts.for_account(account: interest_revenue_account).total
      elsif voucher.present?
        voucher.voucher_amounts.for_account(account: interest_revenue_account).total
      else
        0
      end
    end

    def first_year_interest
      current_interest_config.compute_interest(amount: first_year_principal_balance, number_of_days: number_of_days)
    end

    def second_year_interest
      return 0 if number_of_days <= 365

      current_interest_config.compute_interest(amount: second_year_principal_balance, number_of_days: number_of_days - 365)
    end

    def third_year_interest
      return 0 if number_of_days <= 730

      current_interest_config.compute_interest(amount: third_year_principal_balance, number_of_days: number_of_days - 730)
    end

    def fourth_year_interest
      return 0 if number_of_days <= 1095

      current_interest_config.compute_interest(amount: fourth_year_principal_balance, number_of_days: number_of_days - 1095)
    end

    def fifth_year_interest
      return 0 if number_of_days <= 1460

      current_interest_config.compute_interest(amount: fifth_year_principal_balance, number_of_days: number_of_days - 1460)
    end

    def sixth_year_interest
      return 0 if number_of_days <= 2190

      current_interest_config.compute_interest(amount: fifth_year_principal_balance, number_of_days: number_of_days - 1460)
    end

    def first_year_principal_balance
      loan_amount.amount
    end

    def second_year_principal_balance
      return 0 if number_of_days <= 365

      find_schedule = second_year_principal_balance_schedule_finder.new(loan_application: self).find_schedule
      principal_balance_for(find_schedule)
    end

    def third_year_principal_balance
      return 0 if number_of_days <= 730

      schedule = amortization_schedules.by_oldest_date[23]
      principal_balance_for(schedule)
    end

    def fourth_year_principal_balance
      return 0 if number_of_days <= 1095

      schedule = amortization_schedules.by_oldest_date[35]
      principal_balance_for(schedule)
    end

    def fifth_year_principal_balance
      return 0 if number_of_days <= 1460

      schedule = amortization_schedules.by_oldest_date[47]
      principal_balance_for(schedule)
    end

    def prededucted_interest
      prededucted_interest_calculator.new(loan_application: self).prededucted_interest
    end

    def total_amortizeable_interest
      total_interest - prededucted_interest
    end

    def amortizeable_interest_for(schedule)
      principal_balance_for(schedule) * loan_product_monthly_interest_rate
    end

    def net_proceed
      LoansModule::LoanApplications::NetProceedCalculator.new(loan_application: self).net_proceed
    end

    def status
      if loan.present?
        'Approved'
      else
        'Pending Approval'
      end
    end

    def status_color
      if status == 'Approved'
        'success'
      elsif status == 'Pending Approval'
        'warning'
      end
    end

    def disbursed?
      voucher&.disbursed?
    end

    def schedule_counter
      "LoansModule::ScheduleCounters::#{mode_of_payment.titleize.delete(' ')}Counter".constantize
    end

    def amortization_date_setter
      "LoansModule::AmortizationDateSetters::#{mode_of_payment.titleize.delete(' ')}".constantize
    end

    def second_year_principal_balance_schedule_finder
      "LoansModule::ScheduleFinders::SecondYear::#{mode_of_payment.titleize.delete(' ')}".constantize
    end

    def first_amortization_date
      amortization_date_setter.new(date: application_date, number_of_days: number_of_days).start_date
    end

    def succeeding_amortization_date
      amortization_date_setter.new(date: amortization_schedules.latest.date).start_date
    end

    def schedule_count
      schedule_counter.new(loan_application: self).schedule_count
    end

    def amortizeable_principal(args = {})
      amortizeable_principal_calculator.new(loan_application: self, schedule: args[:schedule]).amortizeable_principal
    end

    # for Loan Protection fund computation
    def number_of_thousands
      loan_amount.amount / 1_000.0
    end

    def add_on_interest
      current_interest_config.compute_interest(amount: loan_amount.amount, term: term)
    end
  end
end
