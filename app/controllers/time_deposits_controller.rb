class TimeDepositsController < ApplicationController
  def index
    if params[:search].present?
      @time_deposits = current_cooperative.time_deposits.text_search(params[:search]).paginate(page: params[:page], per_page: 20)
    else
      @time_deposits = current_cooperative.time_deposits.paginate(page: params[:page], per_page: 20)
    end
  end

  def show
    @time_deposit = current_cooperative.time_deposits.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = TimeDepositPdf.new(@time_deposit, view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Time Deposit.pdf"
      end
    end
  end

  private
  def time_deposit_params
    params.require(:time_deposit_form).permit(:account_number, :or_number, :amount, :date, :member_id, :number_of_days, :payment_type, :cash_account_id)
  end
end
