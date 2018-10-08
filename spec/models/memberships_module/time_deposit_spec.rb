require 'rails_helper'

module MembershipsModule
  describe TimeDeposit do
    context 'associations' do
      it { is_expected.to belong_to :cooperative }
    	it { is_expected.to belong_to :depositor }
    	it { is_expected.to belong_to :time_deposit_product }
      it { is_expected.to have_many :terms }
      it { is_expected.to belong_to :office }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:account).to(:time_deposit_product).with_prefix }
      it { is_expected.to delegate_method(:break_contract_fee).to(:time_deposit_product).with_prefix }
      it { is_expected.to delegate_method(:name).to(:time_deposit_product).with_prefix }
      it { is_expected.to delegate_method(:interest_rate).to(:time_deposit_product).with_prefix }
      it { is_expected.to delegate_method(:full_name).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:name).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:first_and_last_name).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:maturity_date).to(:current_term).with_prefix }
      it { is_expected.to delegate_method(:deposit_date).to(:current_term).with_prefix }
      it { is_expected.to delegate_method(:matured?).to(:current_term).with_prefix }
      it { is_expected.to delegate_method(:name).to(:office).with_prefix }

    end

    describe 'enums' do
      it { is_expected.to define_enum_for(:status).with([:withdrawn]) }
    end

    it "#current_term" do
      time_deposit = create(:time_deposit)
      fixed_term = create(:fixed_term, time_deposit: time_deposit)
      latest_fixed_term = create(:fixed_term, time_deposit: time_deposit)

      expect(time_deposit.current_term).to eql(latest_fixed_term)
      expect(time_deposit.current_term).to_not eql(fixed_term)

    end

    it '#balance' do
      employee = create(:user, role: 'teller')
      time_deposit_product = create(:time_deposit_product)
      time_deposit = create(:time_deposit, time_deposit_product: time_deposit_product)
      entry = build(:entry, commercial_document: time_deposit)
      entry.credit_amounts << create(:credit_amount, account: time_deposit_product.account, amount: 100_000, commercial_document: time_deposit)
      entry.debit_amounts << create(:debit_amount, account: employee.cash_on_hand_account, amount: 100_000, commercial_document: time_deposit)
      entry.save

      expect(time_deposit.balance).to eql(100_000)
    end
  end
end
