require 'rails_helper'

module AccountingModule
  describe DebitAmount do
    it_behaves_like 'a AccountingModule::Amount subtype', kind: :debit_amount
  end
end
