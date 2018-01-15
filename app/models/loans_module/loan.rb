module LoansModule
  class Loan < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, :against => [:borrower_full_name]
    enum mode_of_payment: [:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :lumpsum]
    has_one :disbursement_voucher, class_name: "Voucher", as: :payee
    has_one :first_notice, class_name: "LoansModule::Notices::FirstNotice", as: :notified
    has_one :second_notice, class_name: "LoansModule::Notices::SecondNotice", as: :notified
    has_one :third_notice, class_name: "LoansModule::Notices::ThirdNotice", as: :notified

    belongs_to :borrower, polymorphic: true
    belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
    belongs_to :street, optional: true, class_name: "Addresses::Street"
    belongs_to :barangay, optional: true, class_name: "Addresses::Barangay"
    belongs_to :municipality, optional: true, class_name: "Addresses::Municipality"
    belongs_to :organization, optional: true
    belongs_to :preparer, class_name: "User", foreign_key: 'preparer_id'

    has_many :loan_protection_funds, class_name: "LoansModule::LoanProtectionFund", dependent: :destroy
    has_many :loan_approvals, class_name: "LoansModule::LoanApproval", dependent: :destroy
    has_many :approvers, through: :loan_approvals
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
    has_many :loan_charges, class_name: "LoansModule::LoanCharge", dependent: :destroy
    has_many :loan_charge_payment_schedules, through: :loan_charges
    has_many :charges, through: :loan_charges, source: :chargeable, source_type: "Charge"
    has_many :loan_co_makers, class_name: "LoansModule::LoanCoMaker", dependent: :destroy
    has_many :member_co_makers, through: :loan_co_makers, source: :co_maker, source_type: 'Member'
    has_many :employee_co_makers, through: :loan_co_makers, source: :co_maker, source_type: 'User'
    has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", as: :commercial_document # for adding amounts on voucher
    has_many :amortization_schedules, dependent: :destroy
    has_many :collaterals, class_name: "LoansModule::Collateral", dependent: :destroy
    has_many :real_properties, through: :collaterals
    has_many :notices, as: :notified, dependent: :destroy

    delegate :name, :age, :contact_number, :current_address, to: :borrower,  prefix: true, allow_nil: true
    delegate :name,  to: :loan_product, prefix: true
    delegate :account, :interest_account, :interest_rate, :penalty_account, to: :loan_product, prefix: true
    delegate :name, to: :organization, prefix: true, allow_nil: true
    delegate :full_name, :current_occupation, to: :preparer, prefix: true
    delegate :maximum_loanable_amount, to: :loan_product
    delegate :avatar, to: :borrower

    validates :loan_product_id, :term, :loan_amount, :borrower_id, presence: true
    validates :term, presence: true, numericality: { greater_than: 0.1 }
    validates :loan_amount, numericality: { less_than_or_equal_to: :maximum_loanable_amount }

    def self.loan_payments(options={})
      entries = []
      if options[:from_date] && options[:to_date] && options[:employee_id].present?
        LoansModule::LoanProduct.accounts.each do |account|
          account.credit_entries.entered_on(from_date: options[:from_date], to_date: options[:to_date]).recorded_by(options[:employee_id]).each do |entry|
            entries << entry
          end
        end
      end
      entries
    end
    def loan_payments
      entries = []
        LoansModule::LoanProduct.accounts.each do |account|
          account.credit_amounts.where(commercial_document: self).each do |amount|
            entries << amount.entry
          end
        end
      entries
    end

    def self.borrowers
      User.all + Member.all
    end
    def self.disbursed_loans
      all.select{ |a| a.disbursement.present? }
    end

    def self.disbursed_on(date)
        includes([:entries]).where('entries.entry_date' => (date.beginning_of_day)..(date.end_of_day))
    end

    def self.disbursed_by(employee)
      User.find_by(id: employee.id).disbursed_loans
    end

    def approved?
      approvers.pluck(:id) == User.loan_approvers.pluck(:id)
    end

    def payment_schedules
      amortization_schedules + loan_charge_payment_schedules
    end

    def store_payment_total
      AccountsReceivableStore.new.total_payments(self)
    end
    def penalty_payment_total
      LoanPenalty.new.payments_total(self)
    end
    def penalties_total
      LoanPenalty.new.balance(self)
    end
    # def interest_on_loan
    #   interest = loan_charges.select{|a| a.chargeable.account == a.loan.loan_product_interest_account}.last
    #   interest.charge_amount_with_adjustment
    # end
    def interest_on_loan_balance
      interest = loan_charges.select{|a| a.chargeable.account == self.loan_product_interest_account}.last
      if interest.present?
        interest.amortized_balance
      else
        0
      end
    end

    def co_makers
      employee_co_makers + member_co_makers
    end

    def name
      borrower_name
    end

    def self.aging_for(start_num, end_num)
      aging_loans = []
      aging.each do |loan|
        if (start_num..end_num).include?(loan.number_of_days_past_due)
          aging_loans << loan
        end
      end
      aging_loans
    end

    def is_past_due?
      number_of_days_past_due >=1
    end
    def amortized_principal_for(options={})
      amortization_schedules.scheduled_for(options).sum(&:principal)
    end
    def amortized_interest_for(options={})
      amortization_schedules.scheduled_for(options).sum(&:interest)
    end
    def arrears(options={})
      amortization_schedules.scheduled_for(options).sum(&:total_amortization)
    end

    def total_unpaid_principal_for(date)
      amortized_principal_for(date) - paid_principal_for(date)
    end

    def paid_principal_for(date)
      loan_product_account.credit_entries.where(commercial_document: self)
    end
    def total_deductions(options={})
      amortized_principal_for(options) + amortized_interest_for(options) + arrears(options)
    end

    def first_notice_date
    if amortization_schedules.present?
      amortization_schedules.last.date + 5.days
    else
      Time.zone.now
    end
    end

    def remaining_term
      term - terms_elapsed
    end

    def terms_elapsed
      if disbursed?
        (Time.zone.now.year * 12 + Time.zone.now.month) - (disbursement_date.year * 12 + disbursement_date.month)
      end
    end

    # def interest_on_loan_amount
    #   interest_on_loan_charge
    # end

    def taxable_amount # for documentary_stamp_tax
      loan_amount
    end

    def net_proceed
      if !disbursed?
        loan_amount - loan_charges.total
      else
        disbursement.credit_amounts.distinct.select{|a| User.cash_on_hand_accounts.include?(a.account)}.sum(&:amount)
      end
    end
    def balance_for(schedule)
      loan_amount - LoansModule::AmortizationSchedule.principal_for(schedule, self)
    end
    def unpaid_principal
      loan_amount - paid_principal
    end
    def paid_principal
      LoanPrincipal.new.payments_total(self)
    end
    def total_loan_charges
      loan_charges.total
    end

    def disbursed?
      disbursement.present?
    end

    def principal_balance(options={})
      loan_product_account.balance(commercial_document_id: self.id, from_date: options[:from_date], to_date: options[:to_date])
    end

    def penalty_balance(options={})
      loan_product_penalty_account.balance(from_date: options[:from_date], to_date: options[:to_date], commercial_document_id: self.id)
    end

    def interest_balance(options={})
      loan_product_interest_account.balance(from_date: options[:from_date], to_date: options[:to_date], commercial_document_id: self.id)
    end

    def principal_payments_total(options={})
      loan_product_account.credits_balance(commercial_document_id: self.id, from_date: options[:from_date], to_date: options[:to_date])
    end

    def interest_payments_total(options={})
      loan_product_interest_account.debits_balance(from_date: options[:from_date], to_date: options[:to_date], commercial_document_id: self.id)
    end
    def penalty_payments_total(options={})
      loan_product_penalty_account.debits_balance(from_date: options[:from_date], to_date: options[:to_date], commercial_document_id: self.id)
    end

    def payments_total(options={})
      principal_payments_total(options) + interest_payments_total(options) + penalty_payments_total
    end

    def disbursement
      if disbursement_voucher.present?
         disbursement_voucher.entry
      end
    end

    def maturity_date
      if amortization_schedules.present?
        amortization_schedules.order(created_at: :asc).last.date
      end
    end

    def disbursement_date
      if disbursement.present?
        disbursement.entry_date
      end
    end

    def balance
      loan_amount - payments_total
    end
    def status_color
      'yellow'
    end

    def number_of_days_past_due
      if maturity_date.present?
        ((Time.zone.now - maturity_date)/86400.0).to_i
      else
        0
      end
    end
    def number_of_months_past_due
      number_of_days_past_due / 30
    end

    private
      def set_default_date
        self.application_date ||= Time.zone.now
      end


  end
end
