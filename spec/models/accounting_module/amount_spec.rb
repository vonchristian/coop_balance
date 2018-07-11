require 'rails_helper'
module AccountingModule
  RSpec.describe Amount, type: :model do
    subject { build(:amount) }
    it { is_expected.to_not be_valid }

    describe 'associations' do
      it { is_expected.to belong_to :entry }
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :commercial_document }
      it { is_expected.to belong_to :recorder }
      it { is_expected.to belong_to :cooperative_service }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of     :type }
      it { is_expected.to validate_presence_of     :account }
      it { is_expected.to validate_presence_of     :entry }
      it { is_expected.to validate_presence_of     :amount }
      it { is_expected.to validate_presence_of     :commercial_document_id }
      it { is_expected.to validate_numericality_of :amount }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
      it { is_expected.to delegate_method(:recorder).to(:entry) }
      it { is_expected.to delegate_method(:reference_number).to(:entry) }
      it { is_expected.to delegate_method(:description).to(:entry) }
    end

    it ".entered_on(options={})" do
      employee = create(:user, role: 'teller')
      updated_saving = create(:saving)
      deposit = build(:entry, commercial_document: updated_saving, entry_date: Date.today)
      debit = deposit.credit_amounts << create(:credit_amount, amount: 5_000, commercial_document: updated_saving, account: updated_saving.saving_product_account)
      deposit.debit_amounts << create(:debit_amount, amount: 5_000, commercial_document: updated_saving, account: employee.cash_on_hand_account)
      deposit.save

      expect(described_class.entered_on(from_date: Date.today, to_date: Date.today))
    end
  end
end
