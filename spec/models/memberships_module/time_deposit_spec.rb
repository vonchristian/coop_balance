require 'rails_helper'

module MembershipsModule
  describe TimeDeposit do
    context 'associations' do
    	it { is_expected.to belong_to :depositor }
    	it { is_expected.to belong_to :time_deposit_product }
    	it { is_expected.to have_many :entries }
      it { is_expected.to have_many :fixed_terms }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :depositor_id }
      it { is_expected.to validate_presence_of :depositor_type }
    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:account).to(:time_deposit_product).with_prefix }
      it { is_expected.to delegate_method(:name).to(:time_deposit_product).with_prefix }
      it { is_expected.to delegate_method(:interest_rate).to(:time_deposit_product).with_prefix }
      it { is_expected.to delegate_method(:full_name).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:name).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:first_and_last_name).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:maturity_date).to(:current_term).with_prefix }
      it { is_expected.to delegate_method(:deposit_date).to(:current_term).with_prefix }
      it { is_expected.to delegate_method(:matured?).to(:current_term).with_prefix }
    end

    describe 'enums' do
      it { is_expected.to define_enum_for(:status).with([:withdrawn]) }
    end

    it "#current_term" do
      time_deposit = create(:time_deposit)
      fixed_term = create(:fixed_term, time_deposit: time_deposit)
      last_fixed_term = create(:fixed_term, time_deposit: time_deposit)

      expect(time_deposit.current_term).to eql(last_fixed_term)
      expect(time_deposit.current_term).to_not eql(fixed_term)

    end

    it "#matured?" do
      time_deposit = create(:time_deposit)
      fixed_term = create(:fixed_term, deposit_date: Date.today.last_year, number_of_days: 90, time_deposit: time_deposit)
      expect(fixed_term.matured?).to be true
      expect(time_deposit.matured?).to be true
    end

    it '#balance' do
      account = create(:liability, name: "Time Deposits")
      time_deposit_product = create(:time_deposit_product, account: account)
      time_deposit = create(:time_deposit)

      entry = build(:entry, commercial_document: time_deposit)
      credit_amount = create(:credit_amount, account: account, amount: 100_000)
      debit_amount = create(:debit_amount, account: account, amount: 100_000)

      entry.credit_amounts << credit_amount
      entry.debit_amounts << debit_amount
      expect(time_deposit.balance).to eql(entry.total)
    end

    it "#amount_deposited" do
      account = create(:liability, name: "Time Deposits")
      time_deposit_product = create(:time_deposit_product, account: account)
      time_deposit = create(:time_deposit)

      entry = build(:entry, commercial_document: time_deposit)
      credit_amount = create(:credit_amount, account: account, amount: 100_000)
      debit_amount = create(:debit_amount, account: account, amount: 100_000)

      entry.credit_amounts << credit_amount
      entry.debit_amounts << debit_amount
      expect(time_deposit.amount_deposited).to eql(entry.total)
    end


    it '#set_account_number' do
      time_deposit = create(:time_deposit)

      expect(time_deposit.account_number).to eql(time_deposit.id)
    end
  end
end
