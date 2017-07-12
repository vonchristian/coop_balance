require 'spec_helper'

module AccountingModule
  describe Equity do
    it_behaves_like 'a AccountingModule::Account subtype', kind: :equity, normal_balance: :credit
  end
end
