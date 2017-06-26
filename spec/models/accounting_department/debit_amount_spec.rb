require 'rails_helper'

module AccountingDepartment
  describe DebitAmount do
    it_behaves_like 'a AccountingDepartment::Amount subtype', kind: :debit_amount
  end
end
