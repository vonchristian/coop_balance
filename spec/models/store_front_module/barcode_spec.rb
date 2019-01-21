require 'rails_helper'

module StoreFrontModule
  describe Barcode do
    describe 'associations' do
      it { is_expected.to belong_to :line_item }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :code }
      it { is_expected.to validate_uniqueness_of(:code).scoped_to(:line_item_id) }
    end
  end
end
