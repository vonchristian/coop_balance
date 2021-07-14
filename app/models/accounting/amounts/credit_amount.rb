module Accounting
  module Amounts
    class CreditAmount < ApplicationRecord
      extend AmountBalancing

      monetize :amount_cents, as: :amount

      belongs_to :old_credit_amount, class_name: 'AccountingModule::Amount', foreign_key: 'old_credit_amount_id', optional: true
      belongs_to :account, polymorphic: true
      belongs_to :entry, class_name: 'AccountingModule::Entry'
    end
  end
end
