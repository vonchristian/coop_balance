class ShareCapitalApplicationsController < ApplicationController
  def new
    @subscriber                = params[:subscriber_type].constantize.find(params[:subscriber_id])
    @share_capital_application = ShareCapitalApplicationProcessing.new
  end

  def create
    @subscriber                = params[:share_capital_application_processing][:subscriber_type].constantize.find(params[:share_capital_application_processing][:subscriber_id])
    @share_capital_application = ShareCapitalApplicationProcessing.new(application_params)
    if @share_capital_application.valid?
      @share_capital_application.process!
      redirect_to share_capital_application_voucher_url(share_capital_application_id: @share_capital_application.find_share_capital_application.id, id: @share_capital_application.find_voucher.id), notice: "Voucher created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def application_params
    params.require(:share_capital_application_processing)
          .permit(:subscriber_id, :subscriber_type, :share_capital_product_id,
                  :date_opened, :amount, :reference_number, :description, :employee_id, :account_number,
                  :cash_account_id, :voucher_account_number, :beneficiaries)
  end
end
