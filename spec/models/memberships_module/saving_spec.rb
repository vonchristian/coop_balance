require 'rails_helper'

module MembershipsModule
  describe Saving do
    context "associations" do
      it { is_expected.to belong_to :cooperative }
    	it { is_expected.to belong_to :depositor }
      it { is_expected.to belong_to :office }
    	it { is_expected.to belong_to :saving_product }
      it { is_expected.to belong_to :barangay }
      it { is_expected.to belong_to :liability_account }
      it { is_expected.to belong_to :interest_expense_account }
      it { is_expected.to have_many :ownerships }
      it { is_expected.to have_many :member_co_depositors }
      it { is_expected.to have_many :debit_amounts }
      it { is_expected.to have_many :credit_amounts }
    end
    context 'delegations' do
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
  end
end
