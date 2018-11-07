require 'rails_helper'

describe TimeDepositApplication do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
  end
end
