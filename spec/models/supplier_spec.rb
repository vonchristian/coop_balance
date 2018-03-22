require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe 'associations' do
    it { is_expected.to have_many :vouchers }
    it { is_expected.to have_many :voucher_amounts }
    it { is_expected.to have_many :addresses }
    it { is_expected.to have_many :entries }
    it { is_expected.to have_many :addresses }
    it { is_expected.to have_many :stock_registries }
    it { is_expected.to have_many :purchase_orders }
    it { is_expected.to have_many :purchase_return_orders }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :business_name }
    it { is_expected.to validate_uniqueness_of :business_name }
  end
  describe 'avatar attachment' do
    it { is_expected.to have_attached_file(:avatar) }
    it { is_expected.to validate_attachment_content_type(:avatar).
                allowing('image/png', 'image/gif').
                rejecting('text/plain', 'text/xml') }
  end

  it '#owner_name' do
    supplier = build(:supplier, first_name: 'Von', last_name: 'Halip')

    expect(supplier.owner_name).to eql('Von Halip')
  end
end
