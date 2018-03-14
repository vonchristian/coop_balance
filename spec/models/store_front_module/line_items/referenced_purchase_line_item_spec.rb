require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe ReferencedPurchaseLineItem do
      describe 'associations' do
        it { is_expected.to belong_to :purchase_line_item }
      end
      it "#cost_of_goods_sold" do
      end
    end
  end
end
