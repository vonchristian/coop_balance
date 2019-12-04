require 'rails_helper'

module AccountCreators
  describe TimeDepositApplication do 
    it '#create_accounts!' do 
      time_deposit_application = build(:time_deposit_application, liability_account_id: nil)
      
      described_class.new(time_deposit_application: time_deposit_application).create_accounts!

      expect(time_deposit_application.liability_account).to_not eql nil 
    end
  end 
end