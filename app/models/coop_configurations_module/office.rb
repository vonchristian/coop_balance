module CoopConfigurationsModule
  class Office < ApplicationRecord
    belongs_to :cooperative
    belongs_to :cash_in_vault_account, class_name: "AccountingModule::Account"
    validates :name, presence: true, uniqueness: true
    validates :contact_number, presence: true
    validates :address, presence: true
  end
end
