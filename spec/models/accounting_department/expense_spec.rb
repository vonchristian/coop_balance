require 'spec_helper'

module AccountingDepartment
  describe Expense do
    it_behaves_like 'a AccountingDepartment::Account subtype', kind: :expense, normal_balance: :debit
  end
end
