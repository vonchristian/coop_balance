class BankAccount < ApplicationRecord

  belongs_to :cooperative
  belongs_to :account, class_name: "AccountingModule::Account"
  validates :bank_name, :bank_address, :account_number, presence: true
  validates :account_id, presence: true
  has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
  def balance
   account.balance(commercial_document_id: self.id)
  end

  def deposits
   account.debits_balance(commercial_document_id: self.id)

  end
  def withdrawals
    account.credits_balance(commercial_document_id: self.id)
  end
end
