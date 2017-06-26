require 'spec_helper'

module AccountingDepartment
  describe Revenue do
    it_behaves_like 'a AccountingDepartment::Account subtype', kind: :revenue, normal_balance: :credit
  end
end
