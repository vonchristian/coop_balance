class UtilityBill < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :account_number_search, against: [:account_number]

  belongs_to :merchant
  belongs_to :utility_bill_category
  belongs_to :voucher, optional: true 
  belongs_to :payee, polymorphic: true 
  belongs_to :receivable_account, class_name: "AccountingModule::Account"
end
