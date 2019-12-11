require 'rails_helper'

module TimeDeposits
  describe CertificateNumberGenerator, type: :model do
    it "generate!" do
      cooperative              = create(:cooperative)
      time_deposit_application = create(:time_deposit_application, date_deposited: Date.current, cooperative: cooperative)

      expect(described_class.new(time_deposit_application: time_deposit_application).generate!).to eql '2019-1'

      create(:time_deposit, cooperative: cooperative, date_deposited: Date.current)
      time_deposit_application_2 = create(:time_deposit_application, date_deposited: Date.current, cooperative: cooperative)

      expect(described_class.new(time_deposit_application: time_deposit_application_2).generate!).to eql '2019-2'
    end
  end
end
