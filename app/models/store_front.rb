class StoreFront < ApplicationRecord
  belongs_to :cooperative
  belongs_to :accounts_receivable_account, class_name: "AccountingModule::Account"
  has_many :entries,                       class_name: "AccountingModule::Entry",
                                           as: :origin
  def self.balance(customer)
    balance = []
    all.each do |store_front|
      balance << store_front.accounts_receivable_account.balance(commercial_document_id: customer.id)
    end
    balance.sum
  end
end
