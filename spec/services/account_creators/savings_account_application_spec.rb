require 'rails_helper'

module AccountCreators
  describe SavingsAccountApplication do
    
    it '#create_accounts!' do
      office                      = create(:office)
      liability_account_category  = create(:liability_level_one_account_category, office: office)
      saving_product              = create(:saving_product)
      savings_account_application = build(:savings_account_application, office: office, saving_product: saving_product, liability_account_id: nil)
      create(:office_saving_product, office: office,  saving_product: saving_product, liability_account_category: liability_account_category)
      described_class.new(savings_account_application: savings_account_application).create_accounts!

      expect(savings_account_application.liability_account).to_not eq nil
      expect(office.accounts).to include(savings_account_application.liability_account)
      expect(liability_account_category.accounts).to include(savings_account_application.liability_account)
    end
  end
end
