require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe InternalUseLineItem do
      it_behaves_like 'a StoreFrontModule::LineItem subtype',
      kind: :internal_use_line_item

      describe 'associations' do
        it { is_expected.to belong_to :internal_use_order }
        it { is_expected.to belong_to :purchase_line_item }
      end
      describe 'validations' do
        it { is_expected.to validate_presence_of :purchase_line_item_id }
      end
    end
  end
end

