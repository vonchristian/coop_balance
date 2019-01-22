module LoansModule
  class Loan < ApplicationRecord
    enum status: [:current_loan, :past_due]
    audited
    include PgSearch
    include LoansModule::Loans::Interest
    include LoansModule::Loans::Principal
    include LoansModule::Loans::Penalty
    include LoansModule::Loans::Amortization
    include InactivityMonitoring
    extend PercentActive

    pg_search_scope :text_search, :against => [:borrower_full_name, :tracking_number]
    multisearchable against: [:borrower_full_name]
    enum mode_of_payment: [:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :lumpsum]

    belongs_to :loan_application, class_name: "LoansModule::LoanApplication"
    belongs_to :disbursement_voucher,   class_name: "Voucher", foreign_key: 'disbursement_voucher_id' # move to loan application
    belongs_to :cooperative
    belongs_to :office,                 class_name: "CoopConfigurationsModule::Office"
    belongs_to :archived_by,            class_name: "User", foreign_key: 'archived_by_id'
    belongs_to :borrower,               polymorphic: true # move to loan application
    belongs_to :loan_product,           class_name: "LoansModule::LoanProduct"
    belongs_to :street,                 class_name: "Addresses::Street",
                                        optional: true
    belongs_to :barangay,               class_name: "Addresses::Barangay",
                                        optional: true
    belongs_to :municipality,           class_name: "Addresses::Municipality",
                                        optional: true
    belongs_to :organization,           optional: true
    belongs_to :preparer,               class_name: "User",
                                        foreign_key: 'preparer_id' #move to loan application

    has_many :voucher_amounts,          class_name: "Vouchers::VoucherAmount", as: :commercial_document,
                                        dependent: :destroy # for adding amounts on voucher move to loan application

    has_many :amortization_schedules,   dependent: :destroy
    has_many :amounts, as: :commercial_document, class_name: "AccountingModule::Amount"

    has_many :notices,                  class_name: "LoansModule::Notice",
                                        as: :notified
    has_many :loan_interests,           class_name: "LoansModule::Loans::LoanInterest", dependent: :destroy
    has_many :loan_penalties,           class_name: "LoansModule::Loans::LoanPenalty",  dependent: :destroy
    has_many :loan_discounts,           class_name: "LoansModule::Loans::LoanDiscount", dependent: :destroy
    has_many :notes,                    as: :noteable

    has_many :terms, as: :termable

     has_many :loan_co_makers,           class_name: "LoansModule::LoanCoMaker"

    has_many :member_co_makers,         through: :loan_co_makers, source: :co_maker, source_type: "Member"

    delegate :name, :address, :contact_number, to: :cooperative, prefix: true
    delegate :disbursed?, to: :disbursement_voucher, allow_nil: true #remove
    delegate :effectivity_date, :is_past_due?, :number_of_days_past_due, :remaining_term, :terms_elapsed, :maturity_date, to: :current_term, allow_nil: true
    delegate :first_and_last_name, to: :preparer, prefix: true #remove
    delegate :name, :age, :contact_number, :current_address, :current_address_complete_address, :current_contact_number,  :first_name, to: :borrower,  prefix: true, allow_nil: true
    delegate :name,  to: :loan_product, prefix: true
    delegate :unearned_interest_income_account,
             :current_account,
             :past_due_account,
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
    delegate :accounting_entry, to: :disbursement_voucher, allow_nil: true
    delegate :name, to: :barangay, prefix: true, allow_nil: true

    validates :loan_product_id, :borrower_id, presence: true
    before_save :set_borrower_full_name


    delegate :is_past_due?, :number_of_days_past_due, :remaining_term, :terms_elapsed, :maturity_date, to: :current_term, allow_nil: true
    delegate :number_of_months, to: :current_term, prefix: true
    delegate :term, to: :current_term

    def self.filter_by(args = {})
      date = Date.parse(args[:date].to_s)
      from_date = (date - 1.month).end_of_month
      to_date = date.end_of_month
      if args.present?
        all.where(cancelled: false, loan_product: args[:loan_product]).select { |l| 
          l.principal_balance > 0 && 
          l.amortization_schedules.where(date: from_date..to_date).present? && 
          l.borrower.current_membership.membership_type == args[:membership_type].to_s
        }
      else
        all.where(cancelled: false).select { |l| 
          l.balance > 0
        }
      end
    end

    def self.unpaid
      all.where(cancelled: false, archived: false).select { |l| l.principal_balance > 0 }
    end

    def arrears(args={})
      amortization_schedules.where(date: args[:from_date]..args[:to_date]).sum(:principal)
    end

    def total_deductions(args={})
      amortized_principal_for(from_date: args[:from_date], to_date: args[:to_date]) - 
      amortized_interest_for(from_date: args[:from_date], to_date: args[:to_date]) +
      arrears(from_date: application_date, to_date: args[:from_date].yesterday.end_of_day)
    end

    def net_proceed_and_loans_receivable_account
      accounts = []
      accounts << cooperative.cash_accounts
      accounts << loan_product_current_account
      accounts
    end

    def principal_account
      if current_loan?
        loan_product_current_account
      elsif past_due?
        loan_product_past_due_account
      end
    end

    def current_term
      terms.current
    end

    def disbursement_date
      if disbursed?
        disbursement_voucher.date
      end
    end

    def maturity_date
      current_term.maturity_date
    end

    def self.active
      where(archived: false)
    end

    def self.for_entry(args={})
      entry = args[:entry]
      ids   = entry.amounts.for_loans.pluck(:commercial_document_id)
      where(id: ids.uniq.flatten)
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
      loans = pluck(:id)
      LoansModule::LoanProduct.total_credits_balance(commercial_document: loans)
    end

    def self.not_archived
      where(archived: false)
    end

    def self.archived
      where(archived: true)
    end

    def self.for_street(args={})
      where(street: args[:street])
    end

    def for_barangay(args={})
      where(barangay: args[:barangay])
    end

    def for_organization(args={})
      where(organization: args[:organization])
    end

    def for_municipality(args={})
      where(municipality: args[:municipality])
    end

    def self.current_loans
      not_matured
    end

    def self.not_matured
        active.joins(:terms).where('terms.maturity_date > ?', Date.today)
    end

    def self.past_due_loans(options={})
      if options[:from_date] && options[:to_date]
        from_date = options[:from_date]
        to_date   = options[:to_date]
        range     = DateRange.new(from_date: from_date, to_date: to_date)
        not_archived.disbursed.
        joins(:terms).where('terms.maturity_date' => range.start_date..range.end_date )
      else
        not_archived.disbursed.
        joins(:terms).where('terms.maturity_date < ?', Date.today)
      end
    end

    def self.forwarded_loans
      where(forwarded_loan: true)
    end
    def self.disbursed
      LoansModule::Loan.joins(:disbursement_voucher).merge(Voucher.disbursed)
    end
    def self.disbursed_on(args={})
      from_date = args[:from_date]
      to_date   = args[:to_date]
      range     = DateRange.new(from_date: from_date, to_date: to_date)
      disbursed.joins(:disbursement_voucher).where('vouchers.date' => range.start_date..range.end_date)
    end

    def self.disbursed_by(args={})
      joins(:disbursement_voucher).where('vouchers.disburser_id' => args[:employee_id])
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

    def loan_payments(args={})
      entries = []
      loan_product_current_account.credit_amounts.where(commercial_document: self).each do |amount|
        entries << amount.entry
      end
      loan_product_current_account.credit_amounts.where(commercial_document: self).each do |amount|
        entries << amount.entry
      end

      loan_product_past_due_account.credit_amounts.where(commercial_document: self).each do |amount|
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

    def self.disbursement_entries(args={})
      LoansModule::LoanProduct.accounts.debit_entries.entered_on(args)
    end
    def voucher_amounts_excluding_loan_amount_and_net_proceed
      accounts = []
      Employees::EmployeeCashAccount.cash_accounts.each do |account|
        accounts << account
      end
      accounts << loan_product_current_account
      voucher_amounts.excluding_account(account: accounts )
    end

    def current?
      !is_past_due?
    end


    # def payment_schedules
    #   amortization_schedules
    # end

    def name
      borrower_name
    end

    def documentary_stamp_taxable_amount
      loan_amount
    end

    def net_proceed #move to loan application
      if !disbursed?
        loan_amount - voucher_amounts.sum(&:adjusted_amount)
      else
        amounts = BigDecimal("0")
        cooperative.cash_accounts.each do |account|
          accounting_entry.credit_amounts.where(account: account).each do |amount|
            amounts += amount
          end
        end
        amounts
      end
    end

    def balance_for(schedule)
      loan_amount - amortization_schedules.principal_for(schedule: schedule)
    end

    def payments_total
      principal_payments +
      total_interest_payments +
      penalty_payments
    end

    def balance(args={})
      principal_balance(args) +
      loan_interests_balance(args) +
      loan_penalties_balance(args)
    end


    def loan_interests_balance(args={})
      total_loan_interests -
      total_interest_discounts -
      total_interest_payments
    end

    def total_loan_interests
      loan_interests.total_interests
    end

    def total_interest_discounts
      loan_discounts.interest.total
    end

    def loan_penalties_balance(args={})
      total_loan_penalties -
      total_penalty_discounts -
      total_penalty_payments
    end
    def total_loan_penalties
      loan_penalties.total_amount
    end

    def total_penalty_discounts
      loan_discounts.penalty.total
    end


    def debits_balance(args)
      loan_product_current_account.debits_balance(args.merge(commercial_document: self))
    end

    def credits_balance(args)
      loan_product_current_account.credits_balance(args.merge(commercial_document: self))
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



    private

    def set_borrower_full_name
      self.borrower_full_name = self.borrower.full_name
    end
  end
end
