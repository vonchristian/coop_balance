require 'rails_helper'

module TimeDeposits
  describe CertificateNumberGenerator, type: :model do
    it 'generate!' do
      office                   = create(:office)
      time_deposit_application = create(:time_deposit_application, date_deposited: Date.current.last_year, office: office)
      expect(described_class.new(time_deposit_application: time_deposit_application).generate!).to eql "#{Date.current.last_year.year}-1"

      time_deposit_application_2 = create(:time_deposit_application, date_deposited: Date.current, office: office)

      expect(described_class.new(time_deposit_application: time_deposit_application_2).generate!).to eql "#{Date.current.year}-1"

      time_deposit_application_3 = create(:time_deposit_application, date_deposited: Date.current + 1.day, office: office)

      expect(described_class.new(time_deposit_application: time_deposit_application_3).generate!).to eql "#{Date.current.year}-2"
    end
  end
end
