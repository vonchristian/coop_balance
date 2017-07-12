require 'rails_helper'

module AccountingModule
  describe CreditAmount do
    it_behaves_like 'a AccountingModule::Amount subtype', kind: :credit_amount
  end
end
