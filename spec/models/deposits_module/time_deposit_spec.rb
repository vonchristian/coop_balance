require 'rails_helper'

module DepositsModule
  describe TimeDeposit do
    context 'associations' do
      it { is_expected.to belong_to :cooperative }
    	it { is_expected.to belong_to :depositor }
    	it { is_expected.to belong_to :time_deposit_product }
      it { is_expected.to belong_to :office }
      it { is_expected.to have_one :term }
      it { is_expected.to belong_to :liability_account }
      it { is_expected.to belong_to :interest_expense_account }
      it { is_expected.to belong_to :break_contract_account }
      it { is_expected.to have_many :accountable_accounts }
      it { is_expected.to have_many :accounts }
      it { is_expected.to have_many :entries }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:account).to(:time_deposit_product).with_prefix }
      it { is_expected.to delegate_method(:break_contract_fee).to(:time_deposit_product).with_prefix }
      it { is_expected.to delegate_method(:name).to(:time_deposit_product).with_prefix }
      it { is_expected.to delegate_method(:interest_rate).to(:time_deposit_product).with_prefix }
      it { is_expected.to delegate_method(:full_name).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:name).to(:depositor) }
      it { is_expected.to delegate_method(:first_and_last_name).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:maturity_date).to(:term).with_prefix }
      it { is_expected.to delegate_method(:effectivity_date).to(:term).with_prefix }
      it { is_expected.to delegate_method(:matured?).to(:term).with_prefix }
      it { is_expected.to delegate_method(:name).to(:office).with_prefix }
      it { is_expected.to delegate_method(:balance).to(:liability_account) }
      it { is_expected.to delegate_method(:credits_balance).to(:liability_account) }
      it { is_expected.to delegate_method(:debits_balance).to(:liability_account) }


    end

    describe 'enums' do
      it { is_expected.to define_enum_for(:status).with_values([:withdrawn]) }
    end




  end
end
