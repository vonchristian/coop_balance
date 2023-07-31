module LoansModule
  class Loan < ApplicationRecord
    enum status: [:current_loan, :past_due, :restructured, :under_litigation]
    extend PercentActive

    include PgSearch::Model
    include LoansModule::Loans::Interest
    include LoansModule::Loans::Principal
    include LoansModule::Loans::Penalty
    include LoansModule::Loans::Amortization
    include InactivityMonitoring

    pg_search_scope :text_search,           :against => [:borrower_full_name, :tracking_number]
    pg_search_scope :account_number_search, :against => [:account_number]
   
    multisearchable against: [:borrower_full_name]

    enum mode_of_payment: [:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :lumpsum]

    has_one    :term,                     as: :termable
    belongs_to :loan_aging_group,         class_name: 'LoansModule::LoanAgingGroup'
    belongs_to :loan_application,         class_name: "LoansModule::LoanApplication", optional: true
    belongs_to :disbursement_voucher,     class_name: "Voucher", foreign_key: 'disbursement_voucher_id', optional: true
    belongs_to :cooperative
    belongs_to :office,                   class_name: "Cooperatives::Office"
    belongs_to :archived_by,              class_name: "User", foreign_key: 'archived_by_id', optional: true
    belongs_to :borrower,                 polymorphic: true
    belongs_to :loan_product,             class_name: "LoansModule::LoanProduct"
    belongs_to :street,                   class_name: "Addresses::Street",  optional: true
    belongs_to :barangay,                 class_name: "Addresses::Barangay",  optional: true
    belongs_to :municipality,             class_name: "Addresses::Municipality",optional: true
    belongs_to :organization,             optional: true
    belongs_to :preparer,                 class_name: "User", foreign_key: 'preparer_id', optional: true
    belongs_to :receivable_account,       class_name: 'AccountingModule::Account'
    
    belongs_to :interest_revenue_account, class_name: 'AccountingModule::Account'
    belongs_to :penalty_revenue_account,  class_name: 'AccountingModule::Account'
    belongs_to :accrued_income_account,   class_name: 'AccountingModule::Account', optional: true
    has_many :amortization_schedules,     dependent: :destroy
    #deprecate
    has_many :notices,                    class_name: "LoansModule::Notice",  as: :notified
    has_many :loan_interests,             class_name: "LoansModule::Loans::LoanInterest", dependent: :destroy
    has_many :loan_penalties,             class_name: "LoansModule::Loans::LoanPenalty",  dependent: :destroy
    has_many :loan_discounts,             class_name: "LoansModule::Loans::LoanDiscount", dependent: :destroy
    has_many :notes,                      as: :noteable
    has_many :loan_co_makers,             class_name: "LoansModule::LoanCoMaker"
    has_many :member_co_makers,           through: :loan_co_makers, source: :co_maker, source_type: "Member"
    has_many :loan_agings,                class_name: 'LoansModule::Loans::LoanAging'
    has_many :loan_aging_groups,          through: :loan_agings, class_name: 'LoansModule::LoanAgingGroup'
    has_many :accountable_accounts,       class_name: 'AccountingModule::AccountableAccount', as: :accountable
    has_many :accounts,                   through: :accountable_accounts, class_name: 'AccountingModule::Account'
    has_many :entries,                    through: :accounts, class_name: 'AccountingModule::Entry'
  
    delegate :name, :address, :contact_number, to: :cooperative, prefix: true
    delegate :disbursed?, to: :disbursement_voucher, allow_nil: true #remove
    delegate :effectivity_date, :is_past_due?, :remaining_term, :terms_elapsed, :maturity_date, to: :term, allow_nil: true
    delegate :first_and_last_name, to: :preparer, prefix: true #remove
    delegate :name, :age, :contact_number, :current_address, :current_address_complete_address, :current_contact_number,  :first_name, to: :borrower,  prefix: true, allow_nil: true
    delegate :name,  to: :loan_product, prefix: true
    delegate :payment_processor, to: :loan_product
    delegate :unearned_interest_income_account,
             :current_account,
             :past_due_account,
             :penalty_revenue_account,
             :interest_revenue_account,
             :interest_rebate_account,
             :accrued_income_account,
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
    delegate :name, to: :office, prefix: true

    validates :loan_product_id, :borrower_id, presence: true
   
    delegate :is_past_due?, :number_of_days_past_due, :remaining_term, :terms_elapsed, :maturity_date, to: :term, allow_nil: true
    delegate :number_of_months, to: :term, prefix: true

    delegate :name, to: :receivable_account, prefix: true
    delegate :name, to: :interest_revenue_account, prefix: true
    delegate :name, to: :penalty_revenue_account, prefix: true
    delegate :reference_number, to: :disbursement_voucher, prefix: true, allow_nil: true
    delegate :title, to: :loan_aging_group, prefix: true 
    def self.with_no_terms
      with_terms = Term.where(termable_type: self.to_s).pluck(:termable_id)
      where(id: with_terms)
    end

    def self.receivable_accounts
      ids = pluck(:receivable_account_id)
      AccountingModule::Account.where(id: ids.compact.flatten.uniq)
    end

    def self.interest_revenue_accounts
      ids = pluck(:interest_revenue_account_id)
      AccountingModule::Account.where(id: ids.compact.flatten.uniq)
    end

    def self.penalty_revenue_accounts
      ids = pluck(:penalty_revenue_account_id)
      AccountingModule::Account.where(id: ids.compact.flatten.uniq)
    end

    

    def self.current_loan_agings 
      map{|a| a.current_loan_aging }
    end 

    def self.filter_by(args = {})
      date = Date.parse(args[:date].to_s)
      from_date = (date - 1.month).end_of_month
      to_date = date.end_of_month
      if args.present?
        all.not_cancelled.where(loan_product: args[:loan_product]).select { |l|
          l.principal_balance > 0 &&
          l.amortization_schedules.where(date: from_date..to_date).present? &&
          l.borrower.current_membership.membership_type == args[:membership_type].to_s
        }
      else
        all.not_cancelled.select { |l|
          l.balance > 0
        }
      end
    end

    def ascending_order # sorting loans in reports
      tracking_number.to_i
    end

    def self.unpaid
      where(paid_at: nil)
    end

    def arrears(args={})
      amortization_schedules.where(date: args[:from_date]..args[:to_date]).sum(:principal)
    end

    def balance_for_loan_group(loan_aging_group)
      ::Loans::LoanGroupBalanceCalculator.new(loan: self, loan_aging_group: loan_aging_group).balance
    end

    def interest_rate
      if loan_application.present?
        loan_application.interest_rate
      else
        loan_product.current_interest_config_rate
      end
    end

    def badge_color
      return 'danger' if past_due?
      return 'success' if current_loan?
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
      receivable_account
    end

    def charges
      if not_forwarded?
        if charges_for_loan_product_accounts.count > 1
          charges_including_cash_accounts_and_loan_product_accounts +
          [charges_for_loan_product_accounts.last]
        else
          charges_including_cash_accounts_and_loan_product_accounts
        end
      end
    end

    def charges_including_cash_accounts_and_loan_product_accounts
      disbursement_voucher.voucher_amounts.excluding_account(account: loan_product_current_account)
      .excluding_account(account: Employees::EmployeeCashAccount.cash_accounts).select{|v| v.amount.amount < loan_amount}
    end

    def charges_for_loan_product_accounts
      disbursement_voucher.voucher_amounts.for_account(account: loan_product_current_account).select{|v| v.amount.amount < loan_amount}
    end

    def charges_for_cash_accounts
      disbursement_voucher.voucher_amounts.for_account(account: Employees::EmployeeCashAccount.cash_accounts)
    end

    def first_year_interest
      loan_application.first_year_interest
    end

    def second_year_interest
      loan_application.second_year_interest
    end

    def third_year_interest
      loan_application.third_year_interest
    end

    def fourth_year_interest
      loan_application.fourth_year_interest
    end

    def fifth_year_interest
      loan_application.fifth_year_interest
    end

    def disbursement_date
      if disbursed?
        term.effectivity_date
      end
    end

    

    def self.active
      where(date_archived: nil)
    end

    

    def self.total_balance(args={})
      receivable_accounts.balance(args)
    end
  

    def self.not_archived
      where(date_archived: nil)
    end

    def self.not_cancelled
      where(cancelled: false)
    end

    def self.not_forwarded
      where(forwarded_loan: false)
    end

    def not_forwarded?
      forwarded_loan == false
    end

    def forwarded?
      forwarded_loan == true
    end

    def not_cancelled?
      cancelled == false
    end

    def self.archived
      where.not(date_archived: nil)
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
        active.joins(:term).where('terms.maturity_date > ?', Date.today)
    end

    def self.past_due_loans
      not_cancelled.
      not_archived.
      unpaid.
      joins(:term).where('terms.maturity_date < ?', Date.today)
    end

    def self.past_due_loans_on(from_date:, to_date:)
      range  = DateRange.new(from_date: from_date, to_date: to_date)
      past_due_loans.
      joins(:term).where('terms.maturity_date' => range.start_date..range.end_date )
    end

    def self.forwarded_loans
      where(forwarded_loan: true)
    end
    def self.disbursed
      joins(:disbursement_voucher).merge(Voucher.disbursed)
    end
    def self.disbursed_on(args={})
      from_date = args[:from_date]
      to_date   = args[:to_date]
      range     = DateRange.new(from_date: from_date, to_date: to_date)
      disbursed.merge(Voucher.disbursed).where('vouchers.date' => range.start_date..range.end_date)
    end

    def self.disbursed_by(args={})
      joins(:disbursement_voucher).where('vouchers.disburser_id' => args[:employee_id])
    end

    def self.matured(options={})
      if options[:from_date] && options[:to_date]
        range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
        self.joins(:term).where('terms.maturity_date' => range.start_date..range.end_date )
      else
        self.joins(:term).where('terms.maturity_date < ?', Date.today)
      end
    end

    def self.matured_on(from_date:, to_date:)
        range = DateRange.new(from_date: from_date, to_date: to_date)
        self.joins(:term).where('terms.maturity_date' => range.start_date..range.end_date )

    end

    def self.aging(options={})
      LoansModule::LoansQuery.new.aging(options)
    end

    def self.for_archival_on(args = {})
      from_date = args[:from_date]
      to_date   = args[:to_date]
      range     = DateRange.new(from_date: from_date, to_date: to_date)
      selected_loans = all.not_archived.not_cancelled.where(application_date: range.start_date..range.end_date).select { |a| a.balance.zero? }

    end

    def self.payments_total
      all.map{|loan| loan.payments_total }.sum
    end

    def loan_payments(args = {})
      entries
    end
   

    def current?
      !is_past_due?
    end

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
            amounts += amount.amount
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
      paid_at.present?
    end

    def loan_penalty_computation
      daily_rate = loan_product_penalty_rate / 30.0
      (principal_balance * daily_rate) * number_of_days_past_due
    end

    def loan_interest_computation
      daily_rate = loan_product_interest_rate / 30.0
      (principal_balance * daily_rate) * number_of_days_past_due
    end

    def more_than_twelve_terms_and_more_than_one_year_old?
      #for loan payment principal and interest checking for default values
      term.number_of_months > 12 && (Date.today).to_date.beginning_of_month > application_date + 1.year
    end

    def current_amortized_principal
      amortization_schedules.scheduled_for(from_date: Date.today.beginning_of_month, to_date: Date.today.end_of_month).sum(&:principal)
    end

    def current_amortized_interest
      amortization_schedules.scheduled_for(from_date: Date.today.beginning_of_month, to_date: Date.today.end_of_month).sum(&:interest)
    end

    def amortized_principal
      if forwarded_loan == false
        amortized_principal_for(from_date: loan_application.first_amortization_date.beginning_of_month, to_date: loan_application.first_amortization_date.end_of_month)
      else
        0
      end
    end

    def amortized_interest
      if forwarded_loan == false
        amortized_interest_for(from_date: loan_application.first_amortization_date.beginning_of_month, to_date: loan_application.first_amortization_date.end_of_month)
      else
        0
      end
    end

    def number_of_days_past_due(args={})
      term.number_of_days_past_due(args)
    end
  end
end
