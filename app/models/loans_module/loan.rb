module LoansModule
  class Loan < ApplicationRecord
    audited
    include PgSearch
    include LoansModule::Loans::Interest
    include LoansModule::Loans::Principal
    include LoansModule::Loans::Penalty
    include LoansModule::Loans::Amortization

    pg_search_scope :text_search, :against => [:borrower_full_name, :tracking_number]
    multisearchable against: [:borrower_full_name]
    enum mode_of_payment: [:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :lumpsum]

    belongs_to :disbursement_voucher,      class_name: "Voucher", foreign_key: 'disbursement_voucher_id'
    belongs_to :cooperative
    belongs_to :office, class_name: "CoopConfigurationsModule::Office"
    belongs_to :voucher
    belongs_to :archived_by,            class_name: "User", foreign_key: 'archived_by_id'
    belongs_to :borrower,               polymorphic: true
    belongs_to :loan_product,           class_name: "LoansModule::LoanProduct"
    belongs_to :street,                 class_name: "Addresses::Street",
                                        optional: true
    belongs_to :barangay,               class_name: "Addresses::Barangay",
                                        optional: true
    belongs_to :municipality,           class_name: "Addresses::Municipality",
                                        optional: true
    belongs_to :organization,           optional: true
    belongs_to :preparer,               class_name: "User",
                                        foreign_key: 'preparer_id'

    has_many :entries,                  class_name: "AccountingModule::Entry",
                                        as: :commercial_document,
                                        dependent: :destroy
    has_many :loan_charges,             class_name: "LoansModule::LoanCharge",
                                        dependent: :destroy
    has_many :loan_charge_payment_schedules, through: :loan_charges
    has_many :charges,                  through: :loan_charges
    has_many :voucher_amounts,          class_name: "Vouchers::VoucherAmount", as: :commercial_document # for adding amounts on voucher
    has_many :amortization_schedules,   dependent: :destroy
    has_many :amounts, as: :commercial_document, class_name: "AccountingModule::Amount"

    has_many :notices,                  class_name: "LoansModule::Notice",
                                        as: :notified
    has_many :loan_interests,           class_name: "LoansModule::Loans::LoanInterest"
    has_many :loan_penalties,           class_name: "LoansModule::Loans::LoanPenalty"
    has_many :loan_discounts,           class_name: "LoansModule::Loans::LoanDiscount"
    has_many :notes,                    as: :noteable
    has_many :terms, as: :termable

    delegate :name, :address, :contact_number, to: :cooperative, prefix: true
    delegate :disbursed?, to: :disbursement_voucher, allow_nil: true
    delegate  :effectivity_date, :is_past_due?, :number_of_days_past_due, :remaining_term, :terms_elapsed, :maturity_date, to: :current_term, allow_nil: true
    delegate :first_and_last_name, to: :preparer, prefix: true
    delegate :name, :age, :contact_number, :current_address,  :first_name, to: :borrower,  prefix: true, allow_nil: true
    delegate :name,  to: :loan_product, prefix: true
    delegate :unearned_interest_income_account,
             :loans_receivable_current_account,
             :penalty_revenue_account,
             :interest_revenue_account,
             :interest_rebate_account,
             :interest_rate,
             :penalty_rate,
             :monthly_interest_rate,
             to: :loan_product, prefix: true
    delegate :name, to: :organization, prefix: true, allow_nil: true
    delegate :full_name, :cooperative, :current_occupation, to: :preparer, prefix: true
    delegate :maximum_loanable_amount, to: :loan_product
    delegate :avatar, to: :borrower
    delegate :disbursement_entry, to: :voucher, allow_nil: true
    delegate :disburser, to: :voucher, allow_nil: true
    delegate :name, to: :barangay, prefix: true, allow_nil: true

    validates :loan_product_id,  :loan_amount, :borrower_id, presence: true
    validates :loan_amount, numericality: { less_than_or_equal_to: :maximum_loanable_amount }
    before_save :set_borrower_full_name


    delegate :is_past_due?, :number_of_days_past_due, :remaining_term, :terms_elapsed, :maturity_date, to: :current_term, allow_nil: true
    delegate :number_of_months, to: :current_term, prefix: true
    delegate :term, to: :current_term
    def self.disbursement_vouchers
      ids = pluck(:disbursement_voucher_id)
      Voucher.where(id: ids)
    end
    def current_term
      terms.current
    end
    def disbursement_date
      current_term.effectivity_date
    end
    def maturity_date
      current_term.maturity_date
    end
    def number_of_interest_payments_prededucted
      if interest_on_loan_charge.present?
        interest_on_loan_charge.number_of_interest_payments_prededucted
      else
        0
      end
    end

    def self.active
      where(archived: false)
    end

    def self.total_balance
      ids = pluck(:id)
      LoansModule::LoanProduct.total_balance(commercial_document: ids)
    end

    def self.total_debits_balance
      ids = pluck(:id)
      LoansModule::LoanProduct.total_debits_balance(commercial_document: ids)
    end
     def self.total_credits_balance
      ids = pluck(:id)
      LoansModule::LoanProduct.total_credits_balance(commercial_document: ids)
    end

    def self.not_archived
      where(archived: false)
    end

    def self.archived
      disbursed.where(archived: true)
    end

    def self.balance(options={})
      self.for(options).sum(&:balance)
    end

    def self.for(options={})
      where(street:       options[:street]).
      where(barangay:     options[:barangay]).
      where(organization: options[:organization]).
      where(municipality: options[:municipality])
    end

    def self.current_loans
      active.joins(:terms).where('terms.maturity_date > ?', Date.today)
    end

    def self.not_matured
        active.joins(:terms).where('terms.maturity_date > ?', Date.today)
    end

    def self.past_due(options={})
      if options[:from_date] && options[:to_date]
        from_date = options[:from_date]
        to_date   = options[:to_date]
        range     = DateRange.new(from_date: from_date, to_date: to_date)
        self.active.where.not(disbursement_date: nil).
        joins(:terms).where('terms.maturity_date' => range.start_date..range.end_date )
      else
        self.active.where.not(disbursement_date: nil).
        joins(:terms).where('terms.maturity_date < ?', Date.today)
      end
    end

    def self.disbursed
      joins(:dibursement_voucher).merge(Voucher.disbursed)
    end

    def self.disbursed_by(args={})
      joins(:voucher).where('vouchers.disburser_id' => args[:employee_id])
    end


    def self.matured(options={})
      if options[:from_date] && options[:to_date]
        range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
        self.joins(:terms).where('terms.maturity_date' => range.start_date..range.end_date )
      else
        self.joins(:terms).where('terms.maturity_date < ?', Date.today)
      end
    end

    def self.aging(options={})
      LoansModule::LoansQuery.new.aging(options)
    end

    def self.paid
      all.map{ |a| a.paid? }
    end

    def self.payments_total
      all.map{|loan| loan.payments_total }.sum
    end

    def self.loan_payments(options={})
      all.map{|a| a.loan_payments(options)}
    end

    def loan_payments(options={})
      entries = []
      loan_product_loans_receivable_current_account.credit_amounts.where(commercial_document: self).each do |amount|
        entries << amount.entry
      end

      loan_product_interest_revenue_account.credit_amounts.where(commercial_document: self).each do |amount|
        entries << amount.entry
      end
      loan_product_penalty_revenue_account.credit_amounts.where(commercial_document: self).each do |amount|
        entries << amount.entry
      end
      entries.uniq
    end

    def current?
      !is_past_due?
    end


    def payment_schedules
      amortization_schedules +
      loan_charge_payment_schedules
    end


    def interest_on_loan_charge
      interest = charges.where(account: loan_product_interest_revenue_account)
      loan_charges.find_by(charge: interest)
    end

    def interest_on_loan_balance
      interest_on_loan_charge.balance
    end

    def name
      borrower_name
    end

    def taxable_amount # for documentary_stamp_tax
      loan_amount
    end

    def net_proceed
      if !disbursed?
        loan_amount - voucher_amounts.sum(&:adjusted_amount)
      else
        amounts = []
        User.cash_on_hand_accounts.each do |account|
          disbursement_entry.credit_amounts.where(account: account).each do |amount|
            amounts << amount
          end
        end
        amounts.uniq.sum(&:amount)
      end
    end

    def balance_for(schedule)
      loan_amount - LoansModule::AmortizationSchedule.principal_for(schedule, self)
    end

    def principal_balance_for(schedule) #used to compute interest
      if schedule == self.amortization_schedules.order(date: :asc).first
        loan_amount
      else
        loan_amount - amortization_schedules.principal_for(schedule.previous_schedule, self)
      end
    end

    def total_loan_charges
      loan_charges.total
    end


    def payments_total
      principal_payments +
      interest_payments +
      penalty_payments
    end

    def balance
      principal_balance +
      loan_interests_balance +
      loan_penalties_balance
    end


    def loan_interests_balance
      loan_interests.total -
      loan_discounts.interest.total -
      interest_payments
    end

    def loan_penalties_balance
      loan_penalties.total -
      loan_discounts.penalty.total -
      penalty_payments
    end

    def debits_balance
      loan_product_loans_receivable_current_account.debits_balance(commercial_document: self)
    end

    def credits_balance
      loan_product_loans_receivable_current_account.credits_balance(commercial_document: self)
    end

    def status_color
      if is_past_due?
        'danger'
      elsif paid?
        'success'
      else
        'gray'
      end
    end

    def status_text
      if is_past_due?
        'Past Due'
      elsif paid?
        'Paid'
      else
        'Current'
      end
    end

    def paid?
      disbursed? && balance.zero?
    end

    def loan_penalty_computation
      daily_rate = loan_product_penalty_rate / 30.0
      (principal_balance * daily_rate) * number_of_days_past_due
    end

    def loan_interest_computation
      daily_rate = loan_product_interest_rate / 30.0
      (principal_balance * daily_rate) * number_of_days_past_due
    end

    def first_notice_date
      maturity_date + 10.days
    end
    def second_notice_date
      first_notice_date + 10.days
    end

    private
    def set_default_date
      self.application_date ||= Time.zone.now
    end
    def set_borrower_full_name
      self.borrower_full_name = self.borrower.full_name
    end
  end
end
