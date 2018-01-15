class SupplierPaymentForm
  include ActiveModel::Model
  attr_accessor :supplier_id, :amount, :reference_number, :date, :recorder_id, :description
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
  def find_employee
    User.find_by(id: recorder_id)
  end


  def save_payment
    find_employee.entries.supplier_payment.create!(commercial_document: find_supplier, description: description, reference_number: reference_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def credit_account
    find_employee.cash_on_hand_account
  end
  def debit_account
    AccountingModule::Account.find_by(name: "Accounts Payable-Trade")
  end
end
