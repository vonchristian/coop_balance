class SupplierPaymentForm
  include ActiveModel::Model
  attr_accessor :supplier_id, :amount, :reference_number, :date
  validates :amount, presence: true, numericality: true
  validates :reference_number, presence: true

  def save
    ActiveRecord::Base.transaction do
      save_payment
    end
  end
  def find_supplier
    Supplier.find_by(id: supplier_id)
  end

  def save_payment
    AccountingDepartment::Entry.create!(entry_type: 'supplier_payment', commercial_document: find_supplier, description: 'Payment to supplier', reference_number: reference_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def credit_account
    AccountingDepartment::Account.find_by(name: "Cash on Hand")
  end
  def debit_account
    AccountingDepartment::Account.find_by(name: "Accounts Payable-Trade")
  end
end
