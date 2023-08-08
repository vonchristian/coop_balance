module Offices
  class OfficeLoanProduct < ApplicationRecord
    belongs_to :office,                            class_name: 'Cooperatives::Office'
    belongs_to :loan_product,                      class_name: 'LoansModule::LoanProduct'
    belongs_to :interest_revenue_ledger, class_name: 'AccountingModule::Ledger'
    belongs_to :penalty_revenue_ledger, class_name: 'AccountingModule::Ledger'
    belongs_to :loan_protection_plan_provider,     class_name: 'LoansModule::LoanProtectionPlanProvider', optional: true
    belongs_to :forwarding_account,                class_name: 'AccountingModule::Account'
    has_many   :office_loan_product_aging_groups,  class_name: 'LoansModule::OfficeLoanProductAgingGroup'
    has_many   :loan_aging_groups,                 through: :office_loan_product_aging_groups, class_name: 'LoansModule::LoanAgingGroup'

    validates :loan_product_id, presence: true, uniqueness: { scope: :office_id }

    delegate :name, to: :loan_product
  end
end
