require 'rails_helper'

describe AccountClosingForm, type: :model do
  describe 'amount' do
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_numericality_of :amount }
  end
end
