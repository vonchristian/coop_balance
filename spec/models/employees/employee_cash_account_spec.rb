require 'rails_helper'

module Employees
  describe EmployeeCashAccount do
    describe 'associations' do
      it { is_expected.to belong_to :employee }
      it { is_expected.to belong_to :cash_account }
    end

    describe 'validations' do
      # it 'asset_account?' do
      #   cash_on_hand = create(:asset)
      #   revenue = create(:revenue)
      #   invalid_cash_account = build(:employee_cash_account, cash_account: revenue)
      #   valid_cash_account = build(:employee_cash_account, cash_account: cash_on_hand)
      #
      #   expect(valid_cash_account).to be_valid
      #   expect(invalid_cash_account).to_not be_valid
      #
      #   expect(invalid_cash_account.errors[:cash_account_id]).to eql(["Must be an asset account"])
      # end

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

    it ".default_accounts" do
      cash_on_hand             = create(:asset)
      cash_in_bank             = create(:asset)
      default_cash_account     = create(:employee_cash_account, cash_account: cash_on_hand, default_account: true)
      not_default_cash_account = create(:employee_cash_account, cash_account: cash_in_bank, default_account: false)

      employee = create(:employee)
      employee.cash_accounts << cash_on_hand
      employee.cash_accounts << cash_in_bank

      expect(described_class.default_accounts).to include(default_cash_account)
      expect(described_class.default_accounts).to_not include(not_default_cash_account)
    end

    it ".recent" do
      recent_cash_account = create(:employee_cash_account, created_at: Date.today)
      old_cash_account    = create(:employee_cash_account, created_at: Date.today.yesterday)

      expect(described_class.recent).to eql(recent_cash_account)
      expect(described_class.default_accounts).to_not eql(old_cash_account)
    end

    it ".default_cash_account" do
      default_cash_account     = create(:employee_cash_account, default_account: true, created_at: Date.today)
      not_default_cash_account = create(:employee_cash_account, default_account: true,  created_at: Date.today.yesterday)

      expect(described_class.default_cash_account).to eql(default_cash_account.cash_account)
      expect(described_class.default_cash_account).to_not eql(not_default_cash_account.cash_account)
    end
  end
end
