class TimeDepositApplicationsController < ApplicationController
  def new
    @depositor                = params[:depositor_type].constantize.find(params[:depositor_id])
    @time_deposit_application = TimeDepositApplicationProcessing.new
  end

  def create
    @depositor                = params[:time_deposit_application_processing][:depositor_type].constantize.find(params[:time_deposit_application_processing][:depositor_id])
    @time_deposit_application = TimeDepositApplicationProcessing.new(time_deposit_application_params)
    if @time_deposit_application.valid?
      @time_deposit_application.process!
      redirect_to time_deposit_application_voucher_url(time_deposit_application_id: @time_deposit_application.find_time_deposit_application.id, id: @time_deposit_application.find_voucher.id), notice: "Voucher created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def time_deposit_application_params
    params.require(:time_deposit_application_processing).
    permit(:time_deposit_product_id, :depositor_id, :depositor_type,
    :cash_account_id, :reference_number, :date, :amount, :description, :number_of_days,
    :employee_id, :voucher_account_number, :account_number, :beneficiaries)
  end
end
