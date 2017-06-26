require 'rails_helper'

module AccountingDepartment
  describe CreditAmount do
    it_behaves_like 'a AccountingDepartment::Amount subtype', kind: :credit_amount
  end
end
