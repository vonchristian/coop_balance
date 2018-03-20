require 'spec_helper'

module AccountingModule
  describe Revenue, type: :model do
    it_behaves_like 'a AccountingModule::Account subtype', kind: :revenue, normal_balance: :credit
  end
end
