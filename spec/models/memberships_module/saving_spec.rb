require 'rails_helper'

module MembershipsModule
  describe Saving do
    context "associations" do
      it { is_expected.to belong_to :cooperative }
    	it { is_expected.to belong_to :depositor }
      it { is_expected.to belong_to :office }
    	it { is_expected.to belong_to :saving_product }
    end
    context 'delegations' do
    	it { is_expected.to delegate_method(:name).to(:saving_product).with_prefix }
      it { is_expected.to delegate_method(:interest_expense_account).to(:saving_product).with_prefix }
      it { is_expected.to delegate_method(:closing_account).to(:saving_product).with_prefix }
      it { is_expected.to delegate_method(:name).to(:office).with_prefix }
      it { is_expected.to delegate_method(:account).to(:saving_product).with_prefix }
      it { is_expected.to delegate_method(:name).to(:depositor).with_prefix }
      it { is_expected.to delegate_method(:current_occupation).to(:depositor).with_prefix }
    	it { is_expected.to delegate_method(:interest_rate).to(:saving_product).with_prefix }
    end

    it '.updated_at' do
      updated_saving = create(:saving)
      not_updated_saving = create(:saving)
      employee = create(:user, role: 'teller')
      deposit = build(:entry, commercial_document: updated_saving, entry_date: Date.today)
      deposit.credit_amounts << create(:credit_amount, amount: 5_000, commercial_document: updated_saving, account: updated_saving.saving_product_account)
      deposit.debit_amounts << create(:debit_amount, amount: 5_000, commercial_document: updated_saving, account: employee.cash_on_hand_account)
      deposit.save

      expect(described_class.updated_at(from_date: Date.today, to_date: Date.today)).to include(updated_saving)
      expect(described_class.updated_at(from_date: Date.today, to_date: Date.today)).to_not include(not_updated_saving)
    end

    it '#balance' do
      employee = create(:user, role: 'teller')
      saving = create(:saving)
      deposit = build(:entry, commercial_document: saving)
      deposit.credit_amounts << create(:credit_amount, amount: 5000, commercial_document: saving, account: saving.saving_product_account)
      deposit.debit_amounts << create(:debit_amount, amount: 5_000, commercial_document: saving, account: employee.cash_on_hand_account)
      deposit.save

      expect(saving.balance).to eq(5_000)
    end

    it '#deposits' do
    	employee = create(:user, role: 'teller')
      employee_cash_account = create(:employee_cash_account, employee: employee)
      saving = create(:saving)
      deposit = build(:entry, commercial_document: saving)
      deposit.credit_amounts << build(:credit_amount, amount: 5000, commercial_document: saving, account: saving.saving_product_account)
      deposit.debit_amounts << build(:debit_amount, amount: 5_000, commercial_document: saving, account: employee_cash_account.cash_account)
      deposit.save

      expect(saving.deposits).to eq(5_000)
    end

    it '#withdrawals' do
    	employee = create(:user, role: 'teller')
      saving = create(:saving)
      withdrawal = build(:entry, commercial_document: saving)
      withdrawal.credit_amounts << create(:credit_amount, amount: 500, commercial_document: saving, account: employee.cash_on_hand_account)
      withdrawal.debit_amounts << create(:debit_amount, amount: 500,  commercial_document: saving, account: saving.saving_product_account)
      withdrawal.save

      expect(saving.withdrawals).to eq(500)
    end

    it '#interests_earned' do

    end

    context '#can_withdraw?' do
    	it 'TRUE if balance is greater than 0' do
        employee = create(:user, role: 'teller')
        saving_product = create(:saving_product)
    		saving = create(:saving, saving_product: saving_product)
        deposit = build(:entry, commercial_document: saving)
        deposit.credit_amounts << create(:credit_amount, amount: 5000, commercial_document: saving, account: saving.saving_product_account)
        deposit.debit_amounts << create(:debit_amount, amount: 5_000, commercial_document: saving, account: employee.cash_on_hand_account)
        deposit.save

        expect(saving.balance).to eql(5_000)
        expect(saving.can_withdraw?).to be true
    	end

    	it 'FALSE if balance is less than 0' do
    		saving_product = create(:saving_product)
        saving = create(:saving, saving_product: saving_product)
        deposit = create(:entry_with_credit_and_debit, commercial_document: saving)
        withdrawal = create(:entry_with_credit_and_debit, commercial_document: saving)

        expect(saving.balance).to eql(0)
        expect(saving.can_withdraw?).to be false
    	end
    end
  end
end
