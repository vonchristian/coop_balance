module LoansModule
  class OfficeLoanProductAgingGroup < ApplicationRecord
    belongs_to :office_loan_product,        class_name: "Offices::OfficeLoanProduct"
    belongs_to :loan_aging_group,           class_name: "LoansModule::LoanAgingGroup"
    belongs_to :receivable_ledger, class_name: "AccountingModule::Ledger", foreign_key: "ledger_id"

    validates :loan_aging_group_id, uniqueness: { scope: :office_loan_product_id }

    def self.current
      joins(:loan_aging_group).where("loan_aging_groups.start_num" => 0).where("loan_aging_groups.end_num" => 0).order(created_at: :asc).first
    end
  end
end
