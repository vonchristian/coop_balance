class BankAccountApplicationsController < ApplicationController
  def new
    @bank_account = BankAccountApplicationProcessing.new
  end
  def create
    @bank_account = BankAccountApplicationProcessing.new(bank_account_params)
    if @bank_account.valid?
      @bank_account.process!
      redirect_to bank_account_url(@bank_account.find_bank_account), notice: "Bank account created successfully."
    else
      render :new
    end
  end

  private
  def bank_account_params
    params.require(:bank_account_application_processing).
    permit(:bank_name, :bank_address, :account_number, :voucher_account_number, :cash_account_id,
      :interest_revenue_account_id,
    :amount, :reference_number, :description, :date, :cooperative_id)
  end
end
