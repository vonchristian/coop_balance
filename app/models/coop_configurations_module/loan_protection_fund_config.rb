module CoopConfigurationsModule
  class LoanProtectionFundConfig < ApplicationRecord
    belongs_to :account, class_name: "AccountingModule::Account"
    validates :account_id, presence: true
  end
end
