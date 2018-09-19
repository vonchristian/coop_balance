require 'rails_helper'

RSpec.describe Voucher, type: :model do
  describe 'associations' do
    it { is_expected.to have_one :entry }
    it { is_expected.to belong_to :payee }
    it { is_expected.to belong_to :commercial_document }
    it { is_expected.to belong_to :preparer }
    it { is_expected.to belong_to :disburser }
    it { is_expected.to have_many :voucher_amounts }
  end


  describe 'delegations' do
    it { is_expected.to delegate_method(:full_name).to(:preparer).with_prefix }
    it { is_expected.to delegate_method(:full_name).to(:disburser).with_prefix }
    it { is_expected.to delegate_method(:current_occupation).to(:preparer).with_prefix }
    it { is_expected.to delegate_method(:current_occupation).to(:disburser).with_prefix }
    it { is_expected.to delegate_method(:name).to(:payee).with_prefix }
    it { is_expected.to delegate_method(:avatar).to(:payee) }
  end

  it ".payees" do
  end


  it "#disbursed?" do
    voucher = create(:voucher)
    voucher_2 = create(:voucher)
    entry = create(:entry_with_credit_and_debit)
    voucher.accounting_entry = entry

    expect(voucher.disbursed?).to eql true
    expect(voucher_2.disbursed?).to eql false
  end

  it '.disbursed(options)' do
    voucher = create(:voucher)
    another_voucher = create(:voucher)
    undisbursed_voucher = create(:voucher)
    entry = create(:entry_with_credit_and_debit, entry_date: Date.today.beginning_of_day)
    another_entry = create(:entry_with_credit_and_debit, entry_date: Date.today.tomorrow)
    voucher.accounting_entry = entry
    another_voucher.accounting_entry = another_entry

    expect(Voucher.disbursed(from_date: Date.today.beginning_of_day, to_date: Date.today.end_of_day).pluck(:id)).to include(voucher.id)
    expect(Voucher.disbursed(from_date: Date.today.beginning_of_day, to_date: Date.today.end_of_day).pluck(:id)).to_not include(another_voucher.id)
    expect(Voucher.disbursed(from_date: Date.today.beginning_of_day, to_date: Date.today.end_of_day).pluck(:id)).to_not include(undisbursed_voucher.id)

    expect(Voucher.disbursed(from_date: Date.today.tomorrow.beginning_of_day, to_date: Date.today.tomorrow.end_of_day).pluck(:id)).to include(another_voucher.id)
    expect(Voucher.disbursed(from_date: Date.today.tomorrow.beginning_of_day, to_date: Date.today.tomorrow.end_of_day).pluck(:id)).to_not include(voucher.id)
    expect(Voucher.disbursed(from_date: Date.today.tomorrow.beginning_of_day, to_date: Date.today.tomorrow.end_of_day).pluck(:id)).to_not include(undisbursed_voucher.id)
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
      Voucher.generate_number_for(voucher)
      voucher.save
      expect(voucher.number).to eql('000000000001')
    end
    it 'for succeeding voucher' do
      first_voucher = Voucher.create(number: '000000000001')
      second_voucher = Voucher.new
      Voucher.generate_number_for(second_voucher)
      second_voucher.save

      expect(second_voucher.number).to eql('000000000002')
    end
  end
end
