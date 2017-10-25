require 'rails_helper'

RSpec.describe SavingsAccountConfig, type: :model do
  describe 'associations' do
  end
  describe 'validations' do
    it { is_expected.to validate_numericality_of :closing_account_fee }
  end
end
