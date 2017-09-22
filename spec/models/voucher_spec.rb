require 'rails_helper'

RSpec.describe Voucher, type: :model do
  describe 'associations' do 
    it { is_expected.to belong_to :voucherable }
    it { is_expected.to belong_to :payee }
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
