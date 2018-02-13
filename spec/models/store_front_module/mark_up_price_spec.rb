require 'rails_helper'

module StoreFrontModule
  describe MarkUpPrice do
    describe 'associations' do
      it { is_expected.to belong_to :unit_of_measurement }
    end
  end
end
