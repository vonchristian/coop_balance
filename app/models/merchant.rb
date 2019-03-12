class Merchant < ApplicationRecord
  has_many :wallets, as: :account_owner
  belongs_to :cooperative
  belongs_to :liability_account, class_name: "AccountingModule::Account"
end
