require 'rails_helper'

describe SavingsAccountApplication do
  describe 'associations' do
    it { is_expected.to belongs_to :cooperative }
  end
end
