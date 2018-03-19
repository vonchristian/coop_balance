require 'rails_helper'

module StoreFrontModule
  module Orders
    describe PurchaseReturnOrder do
      describe 'associations' do
        it { is_expected.to have_one :note }
        it { is_expected.to have_many :purchase_return_line_items }
      end
      describe 'delegations' do
        it { is_expected.to delegate_method(:content).to(:note).with_prefix }
        it { is_expected.to delegate_method(:name).to(:supplier).with_prefix }
      end
    end
  end
end
