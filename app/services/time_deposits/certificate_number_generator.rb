module TimeDeposits
  class CertificateNumberGenerator
    attr_reader :time_deposit_application, :cooperative
    def initialize(time_deposit_application:)
      @time_deposit_application = time_deposit_application
      @cooperative              = @time_deposit_application.cooperative
    end

    def generate!
      recent_annual_time_deposits = cooperative.time_deposits.where(date_deposited: Date.current.beginning_of_year..Date.today.end_of_year)
      Date.current.strftime("%Y").to_s + "-" + (recent_annual_time_deposits.size + 1).to_s
    end
  end
end
