require 'rails_helper'

module DepositsModule
  describe Saving do
    describe "associations", type: :model do
      it { is_expected.to belong_to :cooperative }
    	it { is_expected.to belong_to :depositor }
      it { is_expected.to belong_to :office }
    	it { is_expected.to belong_to :saving_product }
      it { is_expected.to belong_to(:barangay).optional }
      it { is_expected.to belong_to :liability_account }
      it { is_expected.to belong_to :interest_expense_account }
      it { is_expected.to have_many :ownerships }
      it { is_expected.to have_many :accountable_accounts }
      it { is_expected.to have_many :accounts }
      it { is_expected.to have_many :entries }
      it { is_expected.to have_many :savings_account_agings }
      it { is_expected.to have_many :savings_aging_groups }
    end

    describe 'delegations' do
    	it { is_expected.to delegate_method(:name).to(:saving_product).with_prefix }
      it { is_expected.to delegate_method(:applicable_rate).to(:saving_product).with_prefix }
      it { is_expected.to delegate_method(:interest_expense_account).to(:saving_product).with_prefix }
      it { is_expected.to delegate_method(:closing_account).to(:saving_product).with_prefix }
      it { is_expected.to delegate_method(:name).to(:office).with_prefix }
      it { is_expected.to delegate_method(:account).to(:saving_product).with_prefix }
      it { is_expected.to delegate_method(:name).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:current_address_complete_address).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:current_contact_number).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:current_occupation).to(:depositor).with_prefix }
    	it { is_expected.to delegate_method(:interest_rate).to(:saving_product).with_prefix }
      it { is_expected.to delegate_method(:balance).to(:liability_account) }
      it { is_expected.to delegate_method(:debits_balance).to(:liability_account) }
      it { is_expected.to delegate_method(:credits_balance).to(:liability_account) }
      it { is_expected.to delegate_method(:name).to(:liability_account).with_prefix }
      it { is_expected.to delegate_method(:name).to(:interest_expense_account).with_prefix }
      it { is_expected.to delegate_method(:title).to(:current_aging_group).with_prefix }
    end


    it '.updated_at' do
      updated_saving     = create(:saving)
      updated_saving.accounts << updated_saving.liability_account
      not_updated_saving = create(:saving)
      employee           = create(:user, role: 'teller')
      cash               = create(:asset)
      deposit            = build(:entry, entry_date: Date.current)
      deposit.credit_amounts.build(amount: 5_000, account: updated_saving.liability_account)
      deposit.debit_amounts.build(amount: 5_000, account: cash)
      deposit.save

      expect(described_class.updated_at(from_date: Date.current, to_date: Date.current)).to include(updated_saving)
      expect(described_class.updated_at(from_date: Date.current, to_date: Date.current)).to_not include(not_updated_saving)
    end
  end
end
