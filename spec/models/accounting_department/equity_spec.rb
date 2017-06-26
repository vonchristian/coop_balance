require 'spec_helper'

module AccountingDepartment
  describe Equity do
    it_behaves_like 'a AccountingDepartment::Account subtype', kind: :equity, normal_balance: :credit
  end
end
