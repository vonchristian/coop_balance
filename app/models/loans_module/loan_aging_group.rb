module LoansModule
  class LoanAgingGroup < ApplicationRecord
    belongs_to :office,                           class_name: "Cooperatives::Office"
    belongs_to :receivable_ledger, class_name: "AccountingModule::Ledger"
    has_many   :loan_agings,                      class_name: "LoansModule::Loans::LoanAging"
    has_many   :loans,                            class_name: "LoansModule::Loan"
    has_many   :office_loan_product_aging_groups, class_name: "LoansModule::OfficeLoanProductAgingGroup"
    has_many   :office_loan_products,             through: :office_loan_product_aging_groups, class_name: "Offices::OfficeLoanProduct"

    validates :title, :start_num, :end_num, presence: true
    validates :start_num, :end_num, numericality: true

    delegate :name, to: :receivable_ledger, prefix: true

    def self.current_loan_aging_group
      where(start_num: 0, end_num: 0).last
    end

    def num_range
      start_num..end_num
    end

    def total_balance(args = {})
      receivable_ledger.balance(args)
    end
  end
end
