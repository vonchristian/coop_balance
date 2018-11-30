require 'rails_helper'

RSpec.describe Voucher, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :commercial_document }
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :cooperative_service }
    it { is_expected.to belong_to :office }
    it { is_expected.to belong_to :accounting_entry }
    it { is_expected.to belong_to :payee }
    it { is_expected.to belong_to :preparer }
    it { is_expected.to belong_to :disburser }
    it { is_expected.to have_many :voucher_amounts }
  end


  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:cooperative).with_prefix }
    it { is_expected.to delegate_method(:abbreviated_name).to(:cooperative).with_prefix }
    it { is_expected.to delegate_method(:address).to(:cooperative).with_prefix }
    it { is_expected.to delegate_method(:contact_number).to(:cooperative).with_prefix }
    it { is_expected.to delegate_method(:address).to(:cooperative).with_prefix }
    it { is_expected.to delegate_method(:contact_number).to(:cooperative).with_prefix }
    it { is_expected.to delegate_method(:full_name).to(:preparer).with_prefix }
    it { is_expected.to delegate_method(:full_name).to(:disburser).with_prefix }
    it { is_expected.to delegate_method(:current_occupation).to(:preparer).with_prefix }
    it { is_expected.to delegate_method(:current_occupation).to(:disburser).with_prefix }
    it { is_expected.to delegate_method(:name).to(:payee).with_prefix }
    it { is_expected.to delegate_method(:avatar).to(:payee) }
  end

  it '.loan_disbursement_vouchers' do
    disbursement_voucher = create(:voucher)
    loan = create(:loan, disbursement_voucher: disbursement_voucher)

    expect(described_class.loan_disbursement_vouchers).to include(disbursement_voucher)
  end

  it ".payees" do
  end


  it "#disbursed?" do
    voucher = create(:voucher)
    voucher_2 = create(:voucher)
    entry = create(:entry_with_credit_and_debit)
    voucher.update_attributes(accounting_entry: entry)

    expect(voucher.disbursed?).to eql true
    expect(voucher_2.disbursed?).to eql false
  end

  it '.disbursed' do
    disbursed_voucher = create(:voucher)
    undisbursed_voucher = create(:voucher)
    entry = create(:entry_with_credit_and_debit, entry_date: Date.today)
    disbursed_voucher.accounting_entry = entry
    disbursed_voucher.save

    expect(described_class.disbursed).to include(disbursed_voucher)
    expect(described_class.disbursed).to_not include(undisbursed_voucher)

  end
  it '.disbursed_on(args={})' do
    disbursed_voucher = create(:voucher)
    another_disbursed_voucher = create(:voucher)
    undisbursed_voucher = create(:voucher)

    entry = create(:entry_with_credit_and_debit, entry_date: Date.today)
    another_entry = create(:entry_with_credit_and_debit, entry_date: Date.today + 1.day)

    disbursed_voucher.accounting_entry = entry
    another_disbursed_voucher.accounting_entry = another_entry
    disbursed_voucher.save
    another_disbursed_voucher.save

    expect(described_class.disbursed_on(from_date: Date.today, to_date: Date.today)).to include(disbursed_voucher)
    expect(described_class.disbursed_on(from_date: Date.today, to_date: Date.today)).to_not include(undisbursed_voucher)
    expect(described_class.disbursed_on(from_date: Date.today, to_date: Date.today)).to_not include(another_disbursed_voucher)

    expect(described_class.disbursed_on(from_date: Date.today + 1.day, to_date: Date.today + 1.day)).to include(another_disbursed_voucher)
    expect(described_class.disbursed_on(from_date: Date.today + 1.day, to_date: Date.today + 1.day)).to_not include(disbursed_voucher)
    expect(described_class.disbursed_on(from_date: Date.today + 1.day, to_date: Date.today + 1.day)).to_not include(undisbursed_voucher)

  end


  describe 'callbacks' do
    it '.set_date' do
      voucher = create(:voucher)

      expect(voucher.date).to be_present
      expect(voucher.date.to_date).to eql Date.today
    end
  end

  describe ".generate_number" do
    it 'for first voucher' do
      Voucher.delete_all
      voucher = Voucher.new
      voucher.number = Voucher.generate_number
      voucher.save
      expect(voucher.number).to eql('000000000001')
    end
    it 'for succeeding voucher' do
      Voucher.delete_all
      voucher = Voucher.new
      voucher.number = Voucher.generate_number
      voucher.save
      
      first_voucher = Voucher.create(number: '000000000001')
      second_voucher = Voucher.new
      second_voucher.number = Voucher.generate_number
      second_voucher.save

      expect(second_voucher.number).to eql('000000000002')
    end
  end
end
