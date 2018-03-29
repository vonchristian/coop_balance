require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe SpoilageLineItem do
      describe 'associations' do
        it { is_expected.to belong_to :spoilage_order }
        it { is_expected.to belong_to :purchase_line_item }
      end
      describe 'delegations' do
        it { is_expected.to delegate_method(:commercial_document).to(:spoilage_order) }
        it { is_expected.to delegate_method(:commercial_document_name).to(:spoilage_order) }
      end
    end
  end
end
