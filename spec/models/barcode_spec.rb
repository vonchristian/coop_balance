require 'rails_helper'

describe Barcode do
  describe 'associations' do
    it { is_expected.to belong_to :line_item }
  end
end
