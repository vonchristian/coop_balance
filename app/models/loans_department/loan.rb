module LoansDepartment
  class Loan < ApplicationRecord
    enum loan_term_duration: [:day, :week, :month, :year]
    enum loan_status: [:application, :approved, :aging]
    belongs_to :member
    belongs_to :loan_product, class_name: "LoansDepartment::LoanProduct"
    has_many :loan_approvals
    has_many :approvers, through: :loan_approvals

    delegate :full_name, to: :member, prefix: true, allow_nil: true
    delegate :name, to: :loan_product, prefix: true, allow_nil: true

    def disbursed?
      disbursement.present?
    end
    
    def payments
      AccountingDepartment::Entry.loan_payment.where(commercial_document: self)
    end

    def disbursement
      AccountingDepartment::Entry.disbursement.where(commercial_document: self)
    end

    def balance
      disbursement.total - payments.total
    end
  end
end
