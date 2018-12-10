require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :office }
    it { is_expected.to belong_to :cash_account }
    it { is_expected.to belong_to :interest_revenue_account }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :bank_name }
    it { is_expected.to validate_presence_of :bank_address }
    it { is_expected.to validate_presence_of :account_number }
  end
end
