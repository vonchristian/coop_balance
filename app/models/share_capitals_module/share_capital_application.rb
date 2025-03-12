module ShareCapitalsModule
  class ShareCapitalApplication < ApplicationRecord
    belongs_to :subscriber, polymorphic: true
    belongs_to :cooperative
    belongs_to :share_capital_product, class_name: "CoopServicesModule::ShareCapitalProduct"
    belongs_to :office,                class_name: "Cooperatives::Office"
    belongs_to :equity_account,        class_name: "AccountingModule::Account"

    validates :subscriber_type, :date_opened, presence: true
    validates :account_number, presence: true, uniqueness: true

    delegate :name, to: :share_capital_product, prefix: true
  end
end
