class TimeDepositsController < ApplicationController
  def index
    if params[:search].present?
      @pagy, @time_deposits = pagy(current_cooperative.time_deposits.text_search(params[:search]))
    else
      @pagy, @time_deposits = pagy(current_cooperative.time_deposits.order(date_deposited: :desc))
    end
  end

  def show
    @time_deposit = current_office.time_deposits.find(params[:id])
    @pagy, @entries      = pagy(@time_deposit.entries)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = TimeDepositPdf.new(time_deposit: @time_deposit, view_context: view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Time Deposit.pdf"
      end
    end
  end

  private
  def time_deposit_params
    params.require(:time_deposit_form).permit(:account_number, :or_number, :amount, :date, :member_id, :number_of_days,  :cash_account_id)
  end
end
