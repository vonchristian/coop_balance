module Offices
  class OfficeLoanProduct < ApplicationRecord
    belongs_to :office,                            class_name: 'Cooperatives::Office'
    belongs_to :loan_product,                      class_name: 'LoansModule::LoanProduct'
    belongs_to :receivable_account_category,       class_name: 'AccountingModule::LevelOneAccountCategory'
    belongs_to :interest_revenue_account_category, class_name: 'AccountingModule::LevelOneAccountCategory'
    belongs_to :penalty_revenue_account_category,  class_name: 'AccountingModule::LevelOneAccountCategory'
    belongs_to :loan_protection_plan_provider,     class_name: 'LoansModule::LoanProtectionPlanProvider', optional: true
    belongs_to :forwarding_account,                class_name: 'AccountingModule::Account'

    validates :loan_product_id, presence: true, uniqueness: { scope: :office_id }
  end
end
