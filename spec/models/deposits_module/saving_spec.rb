require 'rails_helper'

module DepositsModule
  describe Saving do
    describe 'associations', type: :model do
      it { should belong_to :cooperative }
      it { should belong_to :depositor }
      it { should belong_to :office }
      it { should belong_to :saving_product }
      it { should belong_to(:barangay).optional }
      it { should belong_to :liability_account }
      it { should belong_to :interest_expense_account }
      it { should have_many :accountable_accounts }
      it { should have_many :accounts }
      it { should have_many :entries }
      it { should have_many :savings_account_agings }
      it { should have_many :savings_aging_groups }
    end

    describe 'delegations' do
      it { should delegate_method(:name).to(:saving_product).with_prefix }
      it { should delegate_method(:applicable_rate).to(:saving_product).with_prefix }
      it { should delegate_method(:interest_expense_account).to(:saving_product).with_prefix }
      it { should delegate_method(:closing_account).to(:saving_product).with_prefix }
      it { should delegate_method(:name).to(:office).with_prefix }
      it { should delegate_method(:account).to(:saving_product).with_prefix }
      it { should delegate_method(:name).to(:depositor).with_prefix }
      it { should delegate_method(:current_address_complete_address).to(:depositor).with_prefix }
      it { should delegate_method(:current_contact_number).to(:depositor).with_prefix }
      it { should delegate_method(:interest_rate).to(:saving_product).with_prefix }
      it { should delegate_method(:balance).to(:liability_account) }
      it { should delegate_method(:debits_balance).to(:liability_account) }
      it { should delegate_method(:credits_balance).to(:liability_account) }
      it { should delegate_method(:name).to(:liability_account).with_prefix }
      it { should delegate_method(:name).to(:interest_expense_account).with_prefix }
      it { should delegate_method(:title).to(:current_aging_group).with_prefix }
    end

    it '.updated_at' do
      updated_saving = create(:saving)
      updated_saving.accounts << updated_saving.liability_account
      not_updated_saving = create(:saving)
      create(:user, role: 'teller')
      cash               = create(:asset)
      deposit            = build(:entry, entry_date: Date.current)
      deposit.credit_amounts.build(amount: 5_000, account: updated_saving.liability_account)
      deposit.debit_amounts.build(amount: 5_000, account: cash)
      deposit.save

      expect(described_class.updated_at(from_date: Date.current, to_date: Date.current)).to include(updated_saving)
      expect(described_class.updated_at(from_date: Date.current, to_date: Date.current)).not_to include(not_updated_saving)
    end
  end
end
