class Charge < ApplicationRecord
	enum charge_type: [:percent_type, :amount_type]
  belongs_to :credit_account
  belongs_to :debit_account
end
