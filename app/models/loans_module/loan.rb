module LoansModule
  class Loan < ApplicationRecord
    enum loan_term_duration: [:month]
    enum loan_status: [:application, :processing, :approved, :aging]
    enum mode_of_payment: [:monthly, :quarterly, :semi_annually, :lumpsum]
    belongs_to :member
    belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
    has_one :cash_disbursement_voucher, class_name: "Voucher", as: :voucherable
   
    has_many :loan_approvals, class_name: "LoansModule::LoanApproval"
    has_many :approvers, through: :loan_approvals
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document
    has_many :loan_charges, class_name: "LoansModule::LoanCharge"
    has_many :loan_additional_charges
    has_many :charges, through: :loan_charges, source: :chargeable, source_type: "Charge"
    has_many :loan_co_makers, class_name: "LoansModule::LoanCoMaker"
    has_many :co_makers, through: :loan_co_makers, class_name: "Member"
    has_many :amortization_schedules, as: :amortizeable
    has_many :principal_amortization_schedules, as: :amortizeable, class_name: "LoansModule::PrincipalAmortizationSchedule"
    has_many :interest_on_loan_amortization_schedules, as: :amortizeable, class_name: "LoansModule::InterestOnLoanAmortizationSchedule"


    delegate :full_name, to: :member, prefix: true, allow_nil: true
    delegate :name, to: :loan_product, prefix: true, allow_nil: true
    before_save :set_default_date
    after_commit :set_documentary_stamp_tax
    validate :less_than_max_amount?
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
      loan_amount - total_loan_charges
    end
    def total_loan_charges
      loan_charges.total + 
      loan_additional_charges.total
    end
    def set_loan_protection_fee 
      loan_protection_fund = Charge.amount_type.regular.create!(name: 'Loan Protection Fund', amount: LoanProtectionRate.set_amount_for(self), debit_account: AccountingModule::Account.find_by(name: "Cash on Hand"), credit_account: AccountingModule::Revenue.find_by(name: "Service Fees"))
      self.loan_charges.create(chargeable: loan_protection_fund)
    end
    def set_filing_fee
      if loan_amount < 5_000 
        filing_fee = Charge.amount_type.regular.create!(name: 'Filing Fee', amount: 10, debit_account: AccountingModule::Account.find_by(name: "Cash on Hand"), credit_account: AccountingModule::Revenue.find_by(name: "Service Fees"))
      else 
        filing_fee = Charge.amount_type.regular.create!(name: 'Filing Fee', amount: 100, debit_account: AccountingModule::Account.find_by(name: "Cash on Hand"), credit_account: AccountingModule::Revenue.find_by(name: "Service Fees"))
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
      LoansModule::AmortizationSchedule.create_schedule_for(self)
    end
    def disbursed?
      disbursement.present?
    end
    
    def payments
      entries.loan_payment
    end

    def disbursement
      entries.loan_disbursement
    end

    def balance
      disbursement.total - payments.total
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
