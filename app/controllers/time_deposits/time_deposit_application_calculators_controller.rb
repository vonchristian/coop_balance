module TimeDeposits
  class TimeDepositApplicationCalculatorsController < ApplicationController
    def new
      @amount = params[:amount] || 100_000
      @time_deposit_application = TimeDeposits::TimeDepositApplicationCalculator.new
      @time_deposit_products = current_office.time_deposit_products
    end

    def create
      @time_deposit_application = TimeDeposits::TimeDepositApplicationCalculator.new(time_deposit_application_calculator_params)
      @time_deposit_products = current_office.time_deposit_products
      redirect_to new_time_deposit_application_calculator_url(amount: params[:time_deposits_time_deposit_application_calculator][:amount])
    end

    private

    def time_deposit_application_calculator_params
      params.require(:time_deposits_time_deposit_application_calculator)
            .permit(:amount)
    end
  end
end
