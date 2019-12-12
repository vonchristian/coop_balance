module Offices
  class OfficeShareCapitalProduct < ApplicationRecord
    belongs_to :share_capital_product,   class_name: 'CoopServicesModule::ShareCapitalProduct'
    belongs_to :office,                  class_name: 'Cooperatives::Office'
    belongs_to :equity_account_category, class_name: 'AccountingModule::LevelOneAccountCategory'
    belongs_to :forwarding_account,      class_name: 'AccountingModule::Account'
  end
end
