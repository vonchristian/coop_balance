require 'rails_helper'

RSpec.describe TreasuryModule::Voucher do
  describe 'associations' do
    it { should belong_to(:commercial_document).optional }
    it { should belong_to(:cooperative).optional }
    it { should belong_to(:cooperative_service).optional }
    it { should belong_to(:office).optional }
    it { should belong_to(:accounting_entry).optional }
    it { should belong_to :payee }
    it { should belong_to(:preparer).optional }
    it { should belong_to(:disburser).optional }
    it { should have_many :voucher_amounts }
  end

  describe 'delegations' do
    it { should delegate_method(:name).to(:cooperative).with_prefix }
    it { should delegate_method(:abbreviated_name).to(:cooperative).with_prefix }
    it { should delegate_method(:address).to(:cooperative).with_prefix }
    it { should delegate_method(:contact_number).to(:cooperative).with_prefix }
    it { should delegate_method(:address).to(:cooperative).with_prefix }
    it { should delegate_method(:contact_number).to(:cooperative).with_prefix }
    it { should delegate_method(:full_name).to(:preparer).with_prefix }
    it { should delegate_method(:full_name).to(:disburser).with_prefix }
    it { should delegate_method(:current_occupation).to(:preparer).with_prefix }
    it { should delegate_method(:current_occupation).to(:disburser).with_prefix }
    it { should delegate_method(:name).to(:payee).with_prefix }
    it { should delegate_method(:avatar).to(:payee) }
  end

  it '.loan_disbursement_vouchers' do
    disbursement_voucher = create(:voucher)
    create(:loan, disbursement_voucher: disbursement_voucher)

    expect(described_class.loan_disbursement_vouchers).to include(disbursement_voucher)
  end

  it '.payees' do
  end

  it 'contains_cash_accounts' do
    cash_on_hand = create(:asset, name: 'Cash on Hand')
    employee = create(:user)
    employee.cash_accounts << cash_on_hand
    liability    = create(:liability)
    revenue      = create(:revenue)
    cash_voucher = build(:voucher)
    non_cash_voucher = create(:voucher)
    create(:voucher_amount, account: cash_on_hand, voucher: cash_voucher)
    create(:voucher_amount, account: revenue, voucher: cash_voucher)

    create(:voucher_amount, account: liability, voucher: non_cash_voucher)
    create(:voucher_amount, account: liability, voucher: non_cash_voucher)
    non_cash_voucher.save!
    cash_voucher.save!

    expect(described_class.contains_cash_accounts).to include(cash_voucher)
    expect(described_class.contains_cash_accounts).not_to include(non_cash_voucher)
  end

  it '#disbursed?' do
    voucher = create(:voucher)
    voucher_2 = create(:voucher)
    entry = create(:entry_with_credit_and_debit)
    voucher.update(accounting_entry: entry)

    expect(voucher.disbursed?).to be true
    expect(voucher_2.disbursed?).to be false
  end

  it '.disbursed' do
    disbursed_voucher = create(:voucher)
    undisbursed_voucher = create(:voucher)
    entry = create(:entry_with_credit_and_debit, entry_date: Time.zone.today)
    disbursed_voucher.accounting_entry = entry
    disbursed_voucher.save

    expect(described_class.disbursed).to include(disbursed_voucher)
    expect(described_class.disbursed).not_to include(undisbursed_voucher)
  end

  it '.disbursed_on(args={})' do
    cooperative = create(:cooperative)
    disbursed_voucher = create(:voucher)
    another_disbursed_voucher = create(:voucher)
    undisbursed_voucher = create(:voucher)

    entry = create(:entry_with_credit_and_debit, entry_date: Time.zone.today, cooperative: cooperative)
    another_entry = create(:entry_with_credit_and_debit, entry_date: Time.zone.today + 1.day, cooperative: cooperative)

    disbursed_voucher.accounting_entry = entry
    another_disbursed_voucher.accounting_entry = another_entry
    disbursed_voucher.save
    another_disbursed_voucher.save

    expect(described_class.disbursed_on(from_date: Time.zone.today, to_date: Time.zone.today)).to include(disbursed_voucher)
    expect(described_class.disbursed_on(from_date: Time.zone.today, to_date: Time.zone.today)).not_to include(undisbursed_voucher)
    expect(described_class.disbursed_on(from_date: Time.zone.today, to_date: Time.zone.today)).not_to include(another_disbursed_voucher)

    expect(described_class.disbursed_on(from_date: Time.zone.today + 1.day, to_date: Time.zone.today + 1.day)).to include(another_disbursed_voucher)
    expect(described_class.disbursed_on(from_date: Time.zone.today + 1.day, to_date: Time.zone.today + 1.day)).not_to include(disbursed_voucher)
    expect(described_class.disbursed_on(from_date: Time.zone.today + 1.day, to_date: Time.zone.today + 1.day)).not_to include(undisbursed_voucher)
  end

  it 'cancelled?' do
    voucher = create(:voucher)
    cancelled_voucher = create(:voucher, cancelled_at: Date.current)

    expect(voucher.cancelled?).to be false
    expect(cancelled_voucher.cancelled?).to be true
  end

  describe 'callbacks' do
    it '.set_date' do
      voucher = create(:voucher)

      expect(voucher.date).to be_present
      expect(voucher.date.to_date).to eql Time.zone.today
    end
  end
end
