module LoansDepartment
  class Loan < ApplicationRecord
    enum loan_term_duration: [:day, :week, :month, :year]
    belongs_to :member
    belongs_to :loan_product, class_name: "LoansDepartment::LoanProduct"
    has_many :loan_approvals
    has_many :approvers, through: :loan_approvals

    delegate :full_name, to: :member, prefix: true, allow_nil: true
    delegate :name, to: :loan_product, prefix: true, allow_nil: true
  end
end
