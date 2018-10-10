module CoopServicesModule
  class CooperativeService < ApplicationRecord
    belongs_to :cooperative
    has_many :accountable_accounts, as: :accountable, class_name: "AccountingModule::AccountableAccount"
    has_many :accounts, through: :accountable_accounts, class_name: "AccountingModule::Account"
    has_many :entries, class_name: "AccountingModule::Entry"
    has_many :voucher_amounts, as: :commercial_document, class_name: "Vouchers::VoucheAmunt"
  end
end
