require 'rails_helper'

module DepositsModule
  describe TimeDeposit do
    context 'associations' do
      it { should belong_to :cooperative }
      it { should belong_to :depositor }
      it { should belong_to :time_deposit_product }
      it { should belong_to :office }
      it { should have_one :term }
      it { should belong_to :liability_account }
      it { should belong_to :interest_expense_account }
      it { should belong_to :break_contract_account }
      it { should have_many :accountable_accounts }
      it { should have_many :accounts }
      it { should have_many :entries }
    end

    describe 'delegations' do
      it { should delegate_method(:account).to(:time_deposit_product).with_prefix }
      it { should delegate_method(:break_contract_fee).to(:time_deposit_product).with_prefix }
      it { should delegate_method(:name).to(:time_deposit_product).with_prefix }
      it { should delegate_method(:interest_rate).to(:time_deposit_product).with_prefix }
      it { should delegate_method(:full_name).to(:depositor).with_prefix }
      it { should delegate_method(:name).to(:depositor) }
      it { should delegate_method(:first_and_last_name).to(:depositor).with_prefix }
      it { should delegate_method(:maturity_date).to(:term).with_prefix }
      it { should delegate_method(:effectivity_date).to(:term).with_prefix }
      it { should delegate_method(:matured?).to(:term).with_prefix }
      it { should delegate_method(:name).to(:office).with_prefix }
      it { should delegate_method(:balance).to(:liability_account) }
      it { should delegate_method(:credits_balance).to(:liability_account) }
      it { should delegate_method(:debits_balance).to(:liability_account) }
    end

    describe 'enums' do
      it { should define_enum_for(:status).with_values([:withdrawn]) }
    end
  end
end
