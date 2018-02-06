require 'rails_helper'

module StoreFrontModule
  module Orders
    describe SpoilageOrder do
      describe 'associations' do
        it { is_expected.to have_one :note }
        it { is_expected.to have_many :spoilage_order_line_items }
      end
    end
  end
end
