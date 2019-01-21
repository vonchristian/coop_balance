class SavingsAccountApplicationsController < ApplicationController
  def new
    @depositor = params[:depositor_type].constantize.find(params[:depositor_id])
    @savings_account_application = SavingsAccountApplicationProcessing.new
  end
  def create
    @depositor = params[:savings_account_application_processing][:depositor_type].constantize.find(params[:savings_account_application_processing][:depositor_id])
    @savings_account_application = SavingsAccountApplicationProcessing.new(savings_account_application_params)
    if @savings_account_application.valid?
      @savings_account_application.process!
      redirect_to savings_account_application_voucher_url(savings_account_application_id: @savings_account_application.find_savings_account_application.id, id: @savings_account_application.find_voucher.id), notice: "Voucher created successfully."
    else
      render :new
    end
  end

  private
  def savings_account_application_params
    params.require(:savings_account_application_processing).
    permit(:saving_product_id, :depositor_id, :depositor_type,
    :cash_account_id, :reference_number, :date, :amount, :description, :term,
    :employee_id, :voucher_account_number, :account_number, :beneficiaries)
  end
end
