class Charge < ApplicationRecord
	enum charge_type: [:percent_type, :amount_type]
  belongs_to :credit_account, class_name: "AccountingModule::Account"
  belongs_to :debit_account, class_name: "AccountingModule::Account"
end
