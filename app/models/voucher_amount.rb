class VoucherAmount < ApplicationRecord
  belongs_to :account, class_name: "AccountingModule::Account"
  belongs_to :voucher
  belongs_to :commercial_document, polymorphic: true
end
