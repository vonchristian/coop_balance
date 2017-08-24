module LoansModule
  class Loan < ApplicationRecord
    enum loan_term_duration: [:month]
    enum loan_status: [:application, :processing, :approved, :aging]
    enum mode_of_payment: [:monthly, :quarterly, :semi_annually]
    belongs_to :member
    belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
    has_many :loan_approvals, class_name: "LoansModule::LoanApproval"
    has_many :approvers, through: :loan_approvals
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document
    has_many :loan_charges, class_name: "LoansModule::LoanCharge"
    has_many :loan_additional_charges
    has_many :charges, through: :loan_charges
    has_many :loan_co_makers, class_name: "LoansModule::LoanCoMaker"
    has_many :co_makers, through: :loan_co_makers, class_name: "Member"

    delegate :full_name, to: :member, prefix: true, allow_nil: true
    delegate :name, to: :loan_product, prefix: true, allow_nil: true

    after_commit :create_documentary_stamp_tax

    def taxable_amount # for documentary_stamp_tax
      loan_amount
    end
    def net_proceed
      loan_amount - total_loan_charges
    end
    def total_loan_charges
      loan_charges.total + 
      loan_additional_charges.total
    end
    def create_charges
      if self.loan_charges.present?
        loan_charges.destroy_all
      end
      self.loan_product.charges.each do |charge|
        loan_charges.find_or_create_by(charge: charge) 
      end
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
    def create_documentary_stamp_tax
      if self.loan_additional_charges.find_by(name: "Documentary Stamp Tax").present?
        self.loan_additional_charges.where(name: "Documentary Stamp Tax").destroy_all
        self.loan_additional_charges.create(name: 'Documentary Stamp Tax', amount: DocumentaryStampTax.set(self))
      else
        self.loan_additional_charges.create(name: 'Documentary Stamp Tax', amount: DocumentaryStampTax.set(self))
      end
    end
  end
end
