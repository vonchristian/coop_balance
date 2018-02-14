require 'rails_helper'

module StoreFrontModule
  describe MarkUpPrice do
    describe 'associations' do
      it { is_expected.to belong_to :unit_of_measurement }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :price }
      it { is_expected.to validate_numericality_of :price }
    end
  end
end
