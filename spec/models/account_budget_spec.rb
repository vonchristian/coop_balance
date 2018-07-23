require 'rails_helper'

describe AccountBudget do
  describe 'associations' do
    it { is_expected.to belong_to :account }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :account_id }
    it { is_expected.to validate_presence_of :proposed_amount }
    it { is_expected.to validate_presence_of :year }
    it { is_expected.to validate_numericality_of :proposed_amount }
  end
end
