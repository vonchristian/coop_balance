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
    it { is_expected.to delegate_method(:name).to(:payee).with_prefix }

  end

  describe 'callbacks' do
    it '.set_date' do
      voucher = Voucher.new
      voucher.save
      expect(voucher.date).to be_present
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
