require 'rails_helper'

RSpec.describe Voucher, type: :model do
  describe 'associations' do
    it { is_expected.to have_one :entry }
    it { is_expected.to belong_to :payee }
    it { is_expected.to belong_to :preparer }
    it { is_expected.to belong_to :disburser }
    it { is_expected.to have_many :voucher_amounts }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with([:disbursed, :cancelled]) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:full_name).to(:preparer).with_prefix }
    it { is_expected.to delegate_method(:full_name).to(:disburser).with_prefix }
    it { is_expected.to delegate_method(:current_occupation).to(:preparer).with_prefix }
    it { is_expected.to delegate_method(:current_occupation).to(:disburser).with_prefix }
    it { is_expected.to delegate_method(:name).to(:payee).with_prefix }
  end

  it '.disbursed_on(from_date, to_date)' do
    voucher = create(:voucher)
    another_voucher = create(:voucher)
    entry = create(:entry_with_credit_and_debit, entry_date: Date.today.beginning_of_day, commercial_document: voucher)
    another_entry = create(:entry_with_credit_and_debit, entry_date: Date.today.tomorrow, commercial_document: another_voucher)

    expect(Voucher.disbursed_on(from_date: Date.today.beginning_of_day, to_date: Date.today.end_of_day).pluck(:id)).to include(voucher.id)
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
