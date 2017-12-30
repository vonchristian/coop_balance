require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe 'associations' do
    it { is_expected.to have_many :vouchers }
    it { is_expected.to have_many :voucher_amounts }
    it { is_expected.to have_many :raw_material_stocks }
    it { is_expected.to have_many :addresses }
    it { is_expected.to have_many :supplied_stocks }
    it { is_expected.to have_many :entries }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :business_name }
    it { is_expected.to validate_uniqueness_of :business_name }
  end
end
