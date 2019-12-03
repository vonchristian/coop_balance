require 'rails_helper'

module AccountCreators
  describe Saving do
    it '#create_accounts' do
      saving = build(:saving, liability_account_id: nil, interest_expense_account_id: nil)

      described_class.new(saving: saving).create_accounts!

      saving.save!

      expect(saving.liability_account).to_not be nil
      expect(saving.interest_expense_account).to_not be nil
    end
  end
end
