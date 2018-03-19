require 'rails_helper'

module StoreFrontModule
  module Orders
    describe PurchaseOrder do
      describe 'associations' do
        it { is_expected.to have_one :voucher }
        it { is_expected.to have_many :purchase_line_items }
        it { is_expected.to have_many :products }
      end
      describe 'delegations' do
        it { is_expected.to delegate_method(:number).to(:voucher).with_prefix }
        it { is_expected.to delegate_method(:date).to(:voucher).with_prefix }
        it { is_expected.to delegate_method(:disburser_full_name).to(:voucher).with_prefix }
        it { is_expected.to delegate_method(:name).to(:supplier).with_prefix }
      end
    end
  end
end
