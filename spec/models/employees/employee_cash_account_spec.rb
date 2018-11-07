require 'rails_helper'

module Employees
  describe EmployeeCashAccount do
    describe 'associations' do
      it { is_expected.to belong_to :employee }
      it { is_expected.to belong_to :cash_account }
      it { is_expected.to belong_to :cooperative }

    end

    it ".cash_accounts" do
      cash_on_hand = create(:asset)
      cash_in_bank = create(:asset)
      asset = create(:asset)
      employee_cash_account = create(:employee_cash_account, cash_account: cash_on_hand)
      employee_cash_account_2 = create(:employee_cash_account, cash_account: cash_in_bank)

      expect(described_class.cash_accounts).to include(cash_on_hand)
      expect(described_class.cash_accounts).to include(cash_in_bank)
      expect(described_class.cash_accounts).to_not include(asset)
    end
  end
end
