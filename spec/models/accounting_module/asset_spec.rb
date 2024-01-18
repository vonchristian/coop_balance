require 'rails_helper'

module AccountingModule
  describe Asset do
    it_behaves_like 'a AccountingModule::Account subtype', kind: :asset, normal_balance: :debit
  end
end