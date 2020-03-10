require 'rails_helper'

describe Invoice do
  describe 'associations' do
    it { is_expected.to belong_to :invoiceable }
  end
end
