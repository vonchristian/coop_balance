module TimeDeposits
  class CertificateNumberGenerator
    attr_reader :time_deposit_application, :office, :from_date, :to_date
    def initialize(time_deposit_application:)
      @time_deposit_application = time_deposit_application
      @office                   = @time_deposit_application.office
      @from_date                = @time_deposit_application.date_deposited.beginning_of_year
      @to_date                  = @time_deposit_application.date_deposited.end_of_year
    end

    def generate!
      time_deposits_count = office.time_deposit_applications.where(date_deposited: from_date..to_date).size
      from_date.strftime("%Y").to_s + "-" + (time_deposits_count).to_s
    end
  end
end
