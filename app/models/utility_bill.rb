class UtilityBill < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :account_number_search, against: [:account_number]

  belongs_to :merchant
  belongs_to :utility_bill_category
  belongs_to :voucher,            optional: true 
  belongs_to :payee,              polymorphic: true 
  belongs_to :receivable_account, class_name: "AccountingModule::Account"
  
  delegate :name, to: :merchant, prefix: true 
  delegate :name, to: :payee, prefix: true 

  delegate :title, to: :utility_bill_category, prefix: true 


  def paid?
    voucher && voucher.entry_id.present? 
  end 

  def remaining_days
    ((due_date - Time.zone.now)/86400.0).to_i
  end
end
