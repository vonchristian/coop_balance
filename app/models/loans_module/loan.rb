module LoansModule
  class Loan < ApplicationRecord
    enum loan_term_duration: [:month]
    enum loan_status: [:application, :approved, :aging]
    belongs_to :member
    belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
    has_many :loan_approvals, class_name: "LoansModule::LoanApproval"
    has_many :approvers, through: :loan_approvals
    has_many :loan_co_makers, class_name: "LoansModule::LoanCoMaker"
    has_many :co_makers, through: :loan_co_makers, class_name: "Member"
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document
    delegate :full_name, to: :member, prefix: true, allow_nil: true
    delegate :name, to: :loan_product, prefix: true, allow_nil: true

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
  end
end
