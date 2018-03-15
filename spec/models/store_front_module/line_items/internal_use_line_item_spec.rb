require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe InternalUseLineItem do
      describe 'associations' do
        it { is_expected.to belong_to :internal_use_order }
        it { is_expected.to belong_to :purchase_line_item }

      end
    end
  end
end

