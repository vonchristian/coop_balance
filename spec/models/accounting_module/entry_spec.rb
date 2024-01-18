require 'rails_helper'

module AccountingModule
  describe Entry do
    describe 'associations' do
      it { should have_one :voucher }
      it { should belong_to(:cancellation_entry).optional }
      it { should belong_to :commercial_document }
      it { should belong_to :office }
      it { should belong_to :cooperative }
      it { should belong_to(:cancelled_by).optional }
      it { should belong_to :recorder }
      it { should have_many :credit_amounts }
      it { should have_many :debit_amounts }
      it { should have_many :debit_accounts }
      it { should have_many :credit_accounts }
      it { should have_many :accounts }
      it { should have_many :amounts }
    end

    describe 'validations' do
      it { should validate_presence_of :description }
      it { should validate_presence_of :reference_number }
      it { should validate_presence_of :entry_date }
      it { should validate_presence_of :entry_time }
      it { should validate_presence_of :recorder_id }
      it { should validate_presence_of :office_id }
      it { should validate_presence_of :cooperative_id }

      it '#has_credit_amounts?' do
        entry = build(:entry)
        build(:credit_amount, entry: entry)
        entry.save

        expect(entry).not_to be_valid
      end

      it '#has_debit_amounts?' do
        entry = build(:entry)
        build(:debit_amount, entry: entry, amount: 100)
        entry.save

        expect(entry).not_to be_valid
      end

      it '#amounts_cancel?' do
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
      it { should delegate_method(:first_and_last_name).to(:recorder).with_prefix }
      it { should delegate_method(:name).to(:recorder).with_prefix }
      it { should delegate_method(:name).to(:cooperative).with_prefix }
      it { should delegate_method(:name).to(:office).with_prefix }
      it { should delegate_method(:name).to(:commercial_document).with_prefix }
    end

    describe 'nested_attributes' do
      it { should accept_nested_attributes_for(:debit_amounts) }
      it { should accept_nested_attributes_for(:credit_amounts) }
    end

    context 'scopes' do
      it '.recent' do
        old_entry    = create(:entry_with_credit_and_debit, created_at: Time.zone.today.yesterday)
        recent_entry = create(:entry_with_credit_and_debit, created_at: Time.zone.today)

        expect(described_class.recent).to eql recent_entry
        expect(described_class.recent).not_to eql old_entry
      end

      it '.recorder_by(args={})' do
        teller        = create(:teller)
        bookkeeper    = create(:bookkeeper)
        entry         = create(:entry_with_credit_and_debit, recorder: teller)
        another_entry = create(:entry_with_credit_and_debit, recorder: bookkeeper)

        expect(described_class.recorded_by(recorder: teller)).to include(entry)
        expect(described_class.recorded_by(recorder: teller)).not_to include(another_entry)

        expect(described_class.recorded_by(recorder: bookkeeper)).to include(another_entry)
        expect(described_class.recorded_by(recorder: bookkeeper)).not_to include(entry)
      end
    end
  end
end
