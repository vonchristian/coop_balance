module Offices
  class OfficeShareCapitalProduct < ApplicationRecord
    belongs_to :share_capital_product,   class_name: 'CoopServicesModule::ShareCapitalProduct'
    belongs_to :office,                  class_name: 'Cooperatives::Office'
    belongs_to :equity_ledger, class_name: 'AccountingModule::Ledger'
    belongs_to :forwarding_account,      class_name: 'AccountingModule::Account'

    validates :share_capital_product_id, presence: true, uniqueness: { scope: :office_id }

  end
end
