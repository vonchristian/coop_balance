require 'rails_helper'

describe TimeDepositApplication do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :depositor }
    it { is_expected.to belong_to :time_deposit_product }
    it { is_expected.to belong_to :liability_account }
  end
  
  describe 'validations' do
    it { is_expected.to validate_presence_of :number_of_days }
    it { is_expected.to validate_numericality_of :number_of_days }
  end
end
