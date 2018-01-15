require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :bank_name }
    it { is_expected.to validate_presence_of :bank_address }
    it { is_expected.to validate_presence_of :account_number }
  end
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :account }
    it { is_expected.to belong_to :earned_interest_account }
  end
end
