module LoansModule
  class Loan < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, :against => [:borrower_full_name]
    enum loan_term_duration: [:month]
    enum loan_status: [:application, :processing, :approved, :aging]
    enum mode_of_payment: [:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :lumpsum]
    belongs_to :borrower, polymorphic: true
    belongs_to :employee, class_name: "User", foreign_key: 'employee_id' #prepared by signatory
    belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
    belongs_to :street, optional: true
    belongs_to :barangay, optional: true
    belongs_to :municipality, optional: true

    has_one :cash_disbursement_voucher, class_name: "Voucher", as: :voucherable, foreign_key: 'voucherable_id'
   
    has_many :loan_approvals, class_name: "LoansModule::LoanApproval", dependent: :destroy
    has_many :approvers, through: :loan_approvals
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
    has_many :loan_charges, class_name: "LoansModule::LoanCharge", dependent: :destroy
    has_many :loan_additional_charges, dependent: :destroy
    has_many :charges, through: :loan_charges, source: :chargeable, source_type: "Charge"
    has_many :loan_co_makers, class_name: "LoansModule::LoanCoMaker", dependent: :destroy
    has_many :member_co_makers, through: :loan_co_makers, source: :co_maker, source_type: 'Member'
    has_many :employee_co_makers, through: :loan_co_makers, source: :co_maker, source_type: 'User'

    has_many :amortization_schedules, as: :amortizeable, dependent: :destroy
    has_many :principal_amortization_schedules, as: :amortizeable, class_name: "LoansModule::PrincipalAmortizationSchedule", dependent: :destroy
    has_many :interest_on_loan_amortization_schedules, as: :amortizeable, class_name: "LoansModule::InterestOnLoanAmortizationSchedule", dependent: :destroy
    has_many :interest_on_loan_charges, class_name: "LoansModule::InterestOnLoanCharge", as: :chargeable, through: :loan_charges, source: :chargeable, source_type: "LoansModule::InterestOnLoanCharge"
    has_many :collaterals, class_name: "LoansModule::Collateral", dependent: :destroy
    has_many :real_properties, through: :collaterals
    has_many :notices, as: :notified, dependent: :destroy
    has_one :first_notice, class_name: "FirstNotice", as: :notified
    has_one :second_notice, class_name: "SecondNotice", as: :notified
    has_one :third_notice, class_name: "ThirdNotice", as: :notified

    delegate :name, :age, :contact_number, :current_address, to: :borrower,  prefix: true, allow_nil: true
    delegate :name, to: :loan_product, prefix: true, allow_nil: true
    delegate :debit_account, :interest_rate, to: :loan_product, prefix: true
    before_save :set_default_date
    #find aging loans e.g. 1-30 days,
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

    def interest_on_loan_charge
      charge = charges.where(type: "LoansModule::InterestOnLoanCharge").last
      loan_charge = loan_charges.where(chargeable: charge).last
      loan_charge.charge_amount_with_adjustment
    end
    def interest_debit_account
      charge = charges.where(type: "LoansModule::InterestOnLoanCharge").last
      if charge.present?
        charge.credit_account
      end
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
      if total_loan_charges > 0
        loan_amount - total_loan_charges
      else
        loan_amount
      end
    end
    def balance_for(schedule)
      loan_amount - LoansModule::AmortizationSchedule.principal_for(schedule, self)
    end
    def total_loan_charges
      loan_charges.total + 
      loan_additional_charges.total
    end
    def set_loan_protection_fee 
      loan_protection_fund = Charge.amount_type.create!(name: 'Loan Protection Fund', amount: LoanProtectionRate.set_amount_for(self), debit_account: AccountingModule::Account.find_by(name: "Cash on Hand"), credit_account: AccountingModule::Revenue.find_by(name: "Service Fees"))
      self.loan_charges.create(chargeable: loan_protection_fund)
    end
    def set_filing_fee
      if loan_amount < 5_000 
        filing_fee = Charge.amount_type.create!(name: 'Filing Fee', amount: 10, debit_account: AccountingModule::Account.find_by(name: "Cash on Hand"), credit_account: AccountingModule::Revenue.find_by(name: "Service Fees"))
      else 
        filing_fee = Charge.amount_type.create!(name: 'Filing Fee', amount: 100, debit_account: AccountingModule::Account.find_by(name: "Cash on Hand"), credit_account: AccountingModule::Revenue.find_by(name: "Service Fees"))
      end
      self.loan_charges.create(chargeable: filing_fee)
    end

    def set_capital_build_up
      if loan_amount < 50_000
        capital_build_up = Charge.amount_type.create!(name: 'Capital Build Up', amount: (0.02 * loan_amount), debit_account: AccountingModule::Account.find_by(name: "Cash on Hand"), credit_account: AccountingModule::Revenue.find_by(name: "Service Fees"))
      elsif (50_001..100_000.00).include?(loan_amount)
        capital_build_up = Charge.amount_type.create!(name: 'Capital Build Up', amount: (0.15 * loan_amount), debit_account: AccountingModule::Account.find_by(name: "Cash on Hand"), credit_account: AccountingModule::Revenue.find_by(name: "Service Fees"))
      else
        capital_build_up = Charge.amount_type.create!(name: 'Capital Build Up', amount: (0.1 * loan_amount), debit_account: AccountingModule::Account.find_by(name: "Cash on Hand"), credit_account: AccountingModule::Revenue.find_by(name: "Service Fees"))
      end
      self.loan_charges.create(chargeable: capital_build_up)
    end
    def set_interest_on_loan_charge
      LoansModule::InterestOnLoanCharge.set_interest_on_loan_for(self)
    end
    def create_charges
      if self.loan_charges.present?
        loan_charges.destroy_all
      end
      self.loan_product.charges.each do |charge|
        loan_charges.find_or_create_by(chargeable: charge) 
      end
       tax = Charge.amount_type.create!(name: 'Documentary Stamp Tax', amount: DocumentaryStampTax.set(self), debit_account: AccountingModule::Account.find_by(name: "Cash on Hand"),
        credit_account: AccountingModule::Revenue.find_by(name: "Service Fees"))
      self.loan_charges.create!(chargeable: tax)
    end
    def create_amortization_schedule
      if amortization_schedules.present?
        amortization_schedules.destroy_all 
      end
      LoansModule::PrincipalAmortizationSchedule.create_schedule_for(self)
      # LoansModule::InterestOnLoanAmortizationSchedule.create_schedule_for(self)
    end
    def disbursed?
      disbursement.present?
    end
    
    def payments
      entries.loan_payment
    end
    def payments_total
      loan_product_debit_account.credits_balance(commercial_document_id: self.id)
    end

    def disbursement
      if cash_disbursement_voucher.present?
       cash_disbursement_voucher.entry
     end
    end
    def disbursement_date
      if disbursement.present? 
        disbursement.entry_date 
      end
    end

    def balance
      loan_product_debit_account.balance(commercial_document_id: self.id)
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
