module LoansModule
  class Loan < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, :against => [:borrower_full_name]
    enum loan_term_duration: [:month]
    enum loan_status: [:application, :processing, :approved, :disbursed, :past_due, :aging]
    enum mode_of_payment: [:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :lumpsum]
    belongs_to :borrower, polymorphic: true
    belongs_to :employee, class_name: "User", foreign_key: 'employee_id' #prepared by signatory
    belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
    belongs_to :street, optional: true, class_name: "Addresses::Street"
    belongs_to :barangay, optional: true, class_name: "Addresses::Barangay"
    belongs_to :municipality, optional: true, class_name: "Addresses::Municipality"

    has_many :loan_protection_funds, class_name: "LoansModule::LoanProtectionFund", dependent: :destroy
    has_one :cash_disbursement_voucher, class_name: "Voucher", as: :voucherable, foreign_key: 'voucherable_id'
    has_many :loan_protection_funds, class_name: "LoansModule::LoanProtectionFund", dependent: :destroy
    has_many :loan_approvals, class_name: "LoansModule::LoanApproval", dependent: :destroy
    has_many :approvers, through: :loan_approvals
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
    has_many :loan_charges, class_name: "LoansModule::LoanCharge", dependent: :destroy
    has_many :loan_charge_payment_schedules, through: :loan_charges
    has_many :loan_additional_charges, dependent: :destroy
    has_many :charges, through: :loan_charges, source: :chargeable, source_type: "Charge"
    has_many :loan_co_makers, class_name: "LoansModule::LoanCoMaker", dependent: :destroy
    has_many :member_co_makers, through: :loan_co_makers, source: :co_maker, source_type: 'Member'
    has_many :employee_co_makers, through: :loan_co_makers, source: :co_maker, source_type: 'User'

    has_many :amortization_schedules, dependent: :destroy
    has_many :collaterals, class_name: "LoansModule::Collateral", dependent: :destroy
    has_many :real_properties, through: :collaterals
    has_many :notices, as: :notified, dependent: :destroy
    has_one :first_notice, class_name: "LoansModule::Notices::FirstNotice", as: :notified
    has_one :second_notice, class_name: "LoansModule::Notices::SecondNotice", as: :notified
    has_one :third_notice, class_name: "LoansModule::Notices::ThirdNotice", as: :notified

    delegate :name, :age, :contact_number, :current_address, to: :borrower,  prefix: true, allow_nil: true
    delegate :name, :max_loanable_amount, :loan_product_interest_account, to: :loan_product, prefix: true, allow_nil: true
    delegate :account, :interest_rate, to: :loan_product, prefix: true
    before_save :set_default_date

    validates :loan_product_id, presence: true
    validates :term, presence: true, numericality: { greater_than: 0.1 }
    validates :loan_amount, numericality: { less_than: :loan_product_max_loanable_amount}

    #find aging loans e.g. 1-30 days,

    def self.disbursed_on(date)
      disbursed.includes([:entries]).where('entries.entry_date' => (date.beginning_of_day)..(date.end_of_day))
    end
    def payment_schedules
      amortization_schedules + loan_charge_payment_schedules
    end
    def store_payment_total
      entries.map{|a| a.credit_amounts.distinct.where(account: CoopConfigurationsModule::AccountReceivableStoreConfig.account_to_debit).sum(&:amount)}.sum
    end
    def penalty_payment_total
      entries.map{|a| a.credit_amounts.distinct.where(account: CoopConfigurationsModule::LoanPenaltyConfig.account_to_debit).sum(&:amount)}.sum
    end
    def penalties_total
      LoanPenalty.new.balance(self.borrower)
    end
    def interest_on_loan
      interest = loan_charges.select{|a| a.chargeable.account == a.loan.loan_product_loan_product_interest_account}.last
      interest.charge_amount_with_adjustment
    end
    def co_makers
      employee_co_makers + member_co_makers
    end
    def self.borrowers
      User.all + Member.all
    end

    def name
      loan_product_name
    end
    def payable_amount #for voucher
      net_proceed
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
    def self.aging
      all.select{|a| a.past_due? }
    end
    def past_due?
      number_of_days_past_due >=1
    end
    def total_unpaid_principal_for(date)
      amortized_principal_for(date) - paid_principal_for(date)
    end
    def paid_principal_for(date)
      AccountingModule::Account.find_by(name: "Loans Receivable - Current (#{self.loan_product_name.titleize})").credit_entries.where(commercial_document: self)
    end

    def first_notice_date
    if amortization_schedules.present?
      amortization_schedules.last.date + 5.days
    else
      Time.zone.now
    end
    end
    def penalties
      entries.loan_penalty.total
    end

    def remaining_term
      term - terms_elapsed
    end
    def terms_elapsed
      (Time.zone.now.year * 12 + Time.zone.now.month) - (disbursement_date.year * 12 + disbursement_date.month)
    end

    def interest_on_loan_amount
      interest_on_loan_charge
    end
    def monthly_interest_amortization
      interest_on_loan_charge
    end
    def monthly_payment
      loan_amount / term
    end
    def taxable_amount # for documentary_stamp_tax
      loan_amount
    end
    def member_age #testing for LPF
      18
    end
    def net_proceed
      if !disbursed?
        if total_loan_charges > 0
          loan_amount - total_loan_charges
        else
          loan_amount
        end
      else
        entries.loan_disbursement.last.credit_amounts.distinct.select{|a| User.cash_on_hand_accounts.include?(a.account)}.sum(&:amount)
      end
    end
    def balance_for(schedule)
      loan_amount - LoansModule::AmortizationSchedule.principal_for(schedule, self)
    end
    def unpaid_principal
      loan_amount - paid_principal
    end
    def paid_principal
      loan_product_account.balance(commercial_document_id: self.id)
    end
    def total_loan_charges
      loan_charges.total +
      loan_additional_charges.total
    end
    def create_loan_product_charges
      if loan_charges.present?
        loan_charges.destroy_all
      end
      self.loan_product.create_charges_for(self)
    end
    def set_loan_protection_fund
      if loan_protection_funds.present?
        loan_protection_funds.destroy_all
      end
      LoansModule::LoanProtectionFund.set_loan_protection_fund_for(self)
    end

    def create_documentary_stamp_tax
       tax = Charge.amount_type.create!(name: 'Documentary Stamp Tax', amount: DocumentaryStampTax.set(self), account: AccountingModule::Revenue.find_by(name: "Service Fees"))
      self.loan_charges.create!(chargeable: tax)
    end
    def create_amortization_schedule
      if amortization_schedules.present?
        amortization_schedules.destroy_all
      end
      LoansModule::PrincipalAmortizationSchedule.create_schedule_for(self)
      # LoansModule::InterestOnLoanAmortizationSchedule.create_schedule_for(self)
    end
    def interest_on_loan_amount
    end
    def disbursed?
      entries.loan_disbursement.present?
    end

    def payments
      entries.loan_payment
    end
    def payments_total
      loan_product_account.credits_balance(commercial_document_id: self.id)
    end

    def disbursement
      if entries.present?
       entries.loan_disbursement.last
     end
    end
    def disbursement_date
      if disbursement.present?
        disbursement.entry_date
      end
    end

    def balance
      loan_product_account.balance(commercial_document_id: self.id)
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
    def set_borrower_type
      if Member.find_by(id: self.borrower_id).present?
        self.borrower_type = "Member"
      elsif employee_borrower = User.find_by(id: self.borrower_id).present?
       self.borrower_type = "User"
      end
      self.save
    end
    def set_borrower_full_name
      self.borrower_full_name = self.borrower.name
      self.save
    end

    private
      def set_documentary_stamp_tax
      end

      def set_default_date
        self.application_date ||= Time.zone.now
      end
      def less_than_max_amount?
        errors[:loan_amount] << "Amount exceeded maximum allowed amount which is #{self.loan_product.max_loanable_amount}" if self.loan_amount > self.loan_product.max_loanable_amount
      end
  end
end
