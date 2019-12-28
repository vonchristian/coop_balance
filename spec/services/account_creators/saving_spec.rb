require 'rails_helper'

module AccountCreators
  describe Saving do
    it 'create_account!' do
      cooperative           = create(:cooperative)
      office                = create(:office, cooperative: cooperative)
      saving_product        = create(:saving_product, cooperative: cooperative)
      office_saving_product = create(:office_saving_product, office: office, saving_product: saving_product)
      saving                = build(:saving, office: office, liability_account_id: nil, saving_product: saving_product, interest_expense_account_id: nil)
     
      described_class.new(saving: saving).create_accounts!
      saving.save!

      liability_account        = saving.liability_account
      interest_expense_account = saving.interest_expense_account

      expect(saving.liability_account).to eql liability_account
      expect(saving.interest_expense_account).to eql interest_expense_account

      expect(office_saving_product.liability_account_category.accounts).to include(liability_account)
      expect(office_saving_product.interest_expense_account_category.accounts).to include(interest_expense_account)

      expect(office.accounts).to include(liability_account)
      expect(office.accounts).to include(interest_expense_account)

      expect(saving.accounts).to include(liability_account)
      expect(saving.accounts).to include(interest_expense_account)

    end
  end
end
