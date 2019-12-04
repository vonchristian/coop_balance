require 'rails_helper'

module AccountCreators
  describe SavingsAccountApplication do
    it '#create_accounts!' do
      savings_account_application = build(:savings_account_application, liability_account_id: nil)

      described_class.new(savings_account_application: savings_account_application).create_accounts!

      expect(savings_account_application.liability_account).to_not eq nil
    end
  end
end
