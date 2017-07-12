require 'spec_helper'

module AccountingModule
  describe Expense do
    it_behaves_like 'a AccountingModule::Account subtype', kind: :expense, normal_balance: :debit
  end
end
