require 'rails_helper'

module AccountingModule
  describe Entry do
  	describe 'associations' do
      it { is_expected.to have_one :voucher }
      it { is_expected.to belong_to(:official_receipt).optional }
      it { is_expected.to belong_to(:cancellation_entry).optional }
  		it { is_expected.to belong_to :commercial_document }
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to(:cancelled_by).optional }
      it { is_expected.to belong_to :recorder }
      it { is_expected.to have_many :credit_amounts }
      it { is_expected.to have_many :debit_amounts }
      it { is_expected.to have_many :debit_accounts }
      it { is_expected.to have_many :credit_accounts }
      it { is_expected.to have_many :accounts }
      it { is_expected.to have_many :amounts }
      it { is_expected.to have_many :new_debit_amounts }
      it { is_expected.to have_many :new_credit_amounts }


  	end

    describe 'validations' do
      it { is_expected.to validate_presence_of :description }
      it { is_expected.to validate_presence_of :reference_number }
      it { is_expected.to validate_presence_of :entry_date }
      it { is_expected.to validate_presence_of :entry_time }
      it { is_expected.to validate_presence_of :recorder_id }
      it { is_expected.to validate_presence_of :office_id }
      it { is_expected.to validate_presence_of :cooperative_id }

      it '#has_credit_amounts?' do
        entry = build(:entry)
        credit_amount = build(:credit_amount, entry: entry)
        entry.save

        expect(entry).to_not be_valid
      end

      it '#has_debit_amounts?' do
        entry        = build(:entry)
        debit_amount = build(:debit_amount, entry: entry, amount: 100)
        entry.save

        expect(entry).to_not be_valid
      end

      it "#amounts_cancel?" do
        cash_on_hand = create(:asset)
        revenue      = create(:revenue)
        deprecation  = create(:asset)
        property     = create(:asset)
        entry        = build(:entry)
        entry.debit_amounts.build(account: cash_on_hand, amount: 100)
        entry.debit_amounts.build(account: deprecation, amount: 100)
        entry.credit_amounts.build(account: revenue, amount: 100)
        entry.credit_amounts.build(account: property, amount: 100)

        entry.save!

        expect(entry).to be_valid
      end
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:first_and_last_name).to(:recorder).with_prefix }
      it { is_expected.to delegate_method(:name).to(:recorder).with_prefix }
      it { is_expected.to delegate_method(:name).to(:cooperative).with_prefix }
      it { is_expected.to delegate_method(:name).to(:office).with_prefix }
      it { is_expected.to delegate_method(:name).to(:commercial_document).with_prefix }

    end

    describe 'nested_attributes' do
      it { is_expected.to accept_nested_attributes_for(:debit_amounts) }
      it { is_expected.to accept_nested_attributes_for(:credit_amounts) }
    end

    context 'scopes' do
      it '.recent' do
        old_entry    = create(:entry_with_credit_and_debit, created_at: Date.today.yesterday)
        recent_entry = create(:entry_with_credit_and_debit, created_at: Date.today)

        expect(described_class.recent).to eql recent_entry
        expect(described_class.recent).to_not eql old_entry
      end

      it '.recorder_by(args={})' do
        teller        = create(:teller)
        bookkeeper    = create(:bookkeeper)
        entry         = create(:entry_with_credit_and_debit, recorder: teller)
        another_entry = create(:entry_with_credit_and_debit, recorder: bookkeeper)

        expect(described_class.recorded_by(recorder: teller)).to include(entry)
        expect(described_class.recorded_by(recorder: teller)).to_not include(another_entry)

        expect(described_class.recorded_by(recorder: bookkeeper)).to include(another_entry)
        expect(described_class.recorded_by(recorder: bookkeeper)).to_not include(entry)
      end
    end
  end
end
