require 'rails_helper'

module StoreFrontModule
  describe UnitOfMeasurement, type: :model do
    it { is_expected.to belong_to :product }
    it { is_expected.to have_many :mark_up_prices }
  end
end
