class SavingsAccountApplication < ApplicationRecord
  belongs_to :cooperative
  belongs_to :office,            class_name: 'Cooperatives::Office'
  belongs_to :depositor,         polymorphic: true
  belongs_to :saving_product,    class_name: "SavingsModule::SavingProduct"
  belongs_to :liability_account, class_name: 'AccountingModule::Account'
end
