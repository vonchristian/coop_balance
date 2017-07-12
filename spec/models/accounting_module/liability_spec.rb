require 'spec_helper'

module AccountingModule
  describe Liability do
    it_behaves_like 'a AccountingModule::Account subtype', kind: :liability, normal_balance: :credit
  end
end
