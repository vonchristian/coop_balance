require 'rails_helper'

RSpec.describe CoopConfigurationsModule::LoanPenaltyConfig, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :account }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :interest_rate }
    it { is_expected.to validate_presence_of :number_of_days }
    it do
      is_expected.to validate_numericality_of(:interest_rate).is_greater_than_or_equal_to(0.01)
    end
    it { is_expected.to validate_numericality_of :number_of_days }
  end
end
