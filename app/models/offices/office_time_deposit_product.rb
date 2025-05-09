module Offices
  class OfficeTimeDepositProduct < ApplicationRecord
    belongs_to :office,                            class_name: "Cooperatives::Office"
    belongs_to :time_deposit_product,              class_name: "CoopServicesModule::TimeDepositProduct"
    belongs_to :forwarding_account,                class_name: "AccountingModule::Account"
    belongs_to :liability_ledger, class_name: "AccountingModule::Ledger"
    belongs_to :interest_expense_ledger, class_name: "AccountingModule::Ledger"
    belongs_to :break_contract_revenue_ledger, class_name: "AccountingModule::Ledger"

    validates :time_deposit_product_id, uniqueness: { scope: :office_id }
  end
end
