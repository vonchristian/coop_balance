require 'rails_helper'

module TimeDeposits
  describe Opening do
    it "#process!" do
      teller                   = create(:teller)
      time_deposit_product     = create(:time_deposit_product)
      create(:office_time_deposit_product, office: teller.office, time_deposit_product: time_deposit_product)
      time_deposit_application = create(:time_deposit_application, time_deposit_product: time_deposit_product)
      voucher                  = create(:voucher)
      described_class.new(
        time_deposit_application: time_deposit_application,
        voucher: voucher,
        employee: teller
      ).process!

      time_deposit = time_deposit_application.depositor.time_deposits.find_by(account_number: time_deposit_application.account_number)

      expect(time_deposit).to_not eq nil
      expect(time_deposit.liability_account).to eq time_deposit_application.liability_account
      expect(time_deposit.beneficiaries).to eq time_deposit_application.beneficiaries
      expect(time_deposit.time_deposit_product).to eq time_deposit_application.time_deposit_product
      expect(time_deposit.account_number).to eq time_deposit_application.account_number

      puts time_deposit.certificate_number


    end
  end
end
