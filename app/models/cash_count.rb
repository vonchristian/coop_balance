class CashCount < ApplicationRecord
  belongs_to :bill
  belongs_to :cash_account_report, optional: true
  belongs_to :cart, class_name: 'StoreFrontModule::Cart'
  delegate :bill_amount, to: :bill, prefix: true
  def subtotal
    bill.bill_amount * quantity
  end
end
