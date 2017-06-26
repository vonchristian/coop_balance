require 'spec_helper'

module AccountingDepartment
  describe Liability do
    it_behaves_like 'a AccountingDepartment::Account subtype', kind: :liability, normal_balance: :credit
  end
end
