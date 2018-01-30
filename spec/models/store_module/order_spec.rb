require 'rails_helper'

module StoreFrontModule
  describe Order do
    context 'associations' do
    	it { is_expected.to belong_to :customer }
    	it { is_expected.to have_one :official_receipt }
      it { is_expected.to have_one :invoice }
    	it { is_expected.to have_many :line_items }
    end
    context 'delegations' do
      it { is_expected.to delegate_method(:first_and_last_name).to(:customer).with_prefix }
    	it { is_expected.to delegate_method(:number).to(:official_receipt).with_prefix }
      it { is_expected.to delegate_method(:name).to(:customer).with_prefix }

    end

    it { is_expected.to define_enum_for(:payment_type).with([:cash, :credit, :check])}
  end
end
