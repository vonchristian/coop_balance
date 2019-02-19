class Merchant < ApplicationRecord
  belongs_to :cooperative
  belongs_to :liability_account, class_name: "AccountingModule::Account"
end
