require 'rails_helper'

describe BankAccountForm, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :account_id }
    it { is_expected.to validate_presence_of :earned_interest_account_id }
  end
end
