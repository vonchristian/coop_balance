require 'rails_helper'

module AccountCreators
  describe TimeDepositApplication do
    it '#create_accounts!' do
      office = create(:office)
      liability_ledger = create(:liability_ledger)
      time_deposit_product       = create(:time_deposit_product)
      time_deposit_application   = build(:time_deposit_application, office: office, time_deposit_product: time_deposit_product, liability_account_id: nil)
      create(:office_time_deposit_product, office: office, time_deposit_product: time_deposit_product, liability_ledger: liability_ledger)

      described_class.new(time_deposit_application: time_deposit_application).create_accounts!

      expect(time_deposit_application.liability_account).not_to eql nil
      expect(office.accounts).to include(time_deposit_application.liability_account)
      expect(liability_ledger.accounts).to include(time_deposit_application.liability_account)
    end
  end
end
