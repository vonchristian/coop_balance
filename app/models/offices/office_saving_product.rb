module Offices
  class OfficeSavingProduct < ApplicationRecord
    belongs_to :saving_product,   class_name: "SavingsModule::SavingProduct"
    belongs_to :liability_ledger, class_name: "AccountingModule::Ledger"
    belongs_to :interest_expense_ledger, class_name: "AccountingModule::Ledger"

    belongs_to :office,                            class_name: "Cooperatives::Office"
    belongs_to :forwarding_account,                class_name: "AccountingModule::Account"

    validates :saving_product_id, uniqueness: { scope: :office_id }
    delegate :name, to: :saving_product, prefix: true
  end
end
