require 'rails_helper'

module Savings
  describe Opening do
    it '#open_account!' do
      teller                      = create(:teller)
      office                      = teller.office
      saving_product              = create(:saving_product, cooperative: teller.cooperative)
      office_saving_product       = create(:office_saving_product, office: office, saving_product: saving_product)
      savings_account_application = create(:savings_account_application, saving_product: saving_product)
      # saving_group                = create(:saving_group, office: office, start_num: 0, end_num: 30)

      described_class.new(savings_account_application: savings_account_application, employee: teller).open_account!

      saving = office.savings.find_by(account_number: savings_account_application.account_number)

      expect(saving).to be_present

    end
  end
end
