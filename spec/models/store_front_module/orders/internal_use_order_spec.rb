require 'rails_helper'

module StoreFrontModule
  module Orders
    describe InternalUseOrder do
      describe 'associations' do
        it { is_expected.to have_many :internal_use_line_items }
      end
    end
  end
end
