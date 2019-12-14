require 'rails_helper'

module AccountingModule
  module Entries
    describe ReversalVoucherProcessing, type: :model do
      describe 'attributes' do
        it { is_expected.to respond_to(:entry_id) }
        it { is_expected.to respond_to(:employee_id) }
        it { is_expected.to respond_to(:description) }
        it { is_expected.to respond_to(:account_number) }

      end
      describe 'validations' do
        it { is_expected.to validate_presence_of :entry_id }
        it { is_expected.to validate_presence_of :employee_id }
        it { is_expected.to validate_presence_of :description }
        it { is_expected.to validate_presence_of :account_number }
      end

      it '#process' do
        member     = create(:member)
        bookkeeper = create(:bookkeeper)
        cash       = create(:asset)
        revenue    = create(:revenue)

        entry      = build(:entry, entry_date: Date.current, commercial_document: member, office: bookkeeper.office)
        entry.debit_amounts.build(account: cash,    amount: 100)
        entry.credit_amounts.build(account: revenue, amount: 100)
        entry.save!

        expect(cash.balance).to eql 100
        expect(revenue.balance).to eql 100

        described_class.new(
          entry_id:       entry.id,
          employee_id:    bookkeeper.id,
          description:    'wrong entry',
          account_number: "ab341212-f0b4-416c-8a8d-a2f16d9e2606"
        ).process!

        voucher = bookkeeper.office.vouchers.find_by(account_number: "ab341212-f0b4-416c-8a8d-a2f16d9e2606")

        expect(voucher.voucher_amounts.debit.pluck(:account_id)).to include revenue.id
        expect(voucher.voucher_amounts.credit.pluck(:account_id)).to include cash.id
        expect(voucher.preparer).to eq bookkeeper
        expect(voucher.date).to eq entry.entry_date
        expect(voucher.payee).to eq entry.commercial_document
      end
    end
  end
end
