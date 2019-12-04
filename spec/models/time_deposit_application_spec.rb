require 'rails_helper'

describe TimeDepositApplication do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :depositor }
    it { is_expected.to belong_to :time_deposit_product }
    it { is_expected.to belong_to :liability_account }
  end
end
