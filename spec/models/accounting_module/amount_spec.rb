require 'rails_helper'
module AccountingModule
  RSpec.describe Amount, type: :model do
    subject { build(:amount) }
    it { is_expected.to_not be_valid }

    describe 'associations' do
      it { is_expected.to belong_to :entry }
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :commercial_document }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of     :type }
      it { is_expected.to validate_presence_of     :account }
      it { is_expected.to validate_presence_of     :entry }
      it { is_expected.to validate_presence_of     :amount }
      it { is_expected.to validate_presence_of     :commercial_document_id }
      it { is_expected.to validate_presence_of     :commercial_document_type }
      it { is_expected.to validate_numericality_of :amount }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
      it { is_expected.to delegate_method(:recorder).to(:entry) }
      it { is_expected.to delegate_method(:reference_number).to(:entry) }
      it { is_expected.to delegate_method(:description).to(:entry) }
      it { is_expected.to delegate_method(:entry_date).to(:entry) }
      it { is_expected.to delegate_method(:name).to(:recorder).with_prefix }

    end

    context 'scopes' do
      it '.for_account' do
        asset = create(:asset)
        equity = create(:equity)
        amount = create(:debit_amount, account: asset)

        expect(described_class.for_account(account_id: asset.id)).to include(amount)
        expect(described_class.for_account(account_id: equity.id)).to_not include(amount)

      end
    end


    it "#entered_on(args)" do
      entry = create(:entry_with_credit_and_debit, entry_date: Date.today)

      expect(described_class.entered_on(from_date: Date.today, to_date: Date.today).pluck(:id)).to include(entry.amounts.pluck(:id))

    end

    it "#debit?" do
      debit_amount = create(:debit_amount)
      credit_amount = create(:credit_amount)

      expect(debit_amount.debit?).to be true
      expect(credit_amount.debit?).to be false
    end

    it "#credit?" do
      debit_amount = create(:debit_amount)
      credit_amount = create(:credit_amount)

      expect(debit_amount.credit?).to be false
      expect(credit_amount.credit?).to be true
    end
  end
end
