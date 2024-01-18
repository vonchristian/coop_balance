class VouchersController < ApplicationController
  def index
    @vouchers = if params[:search].present?
                  current_cooperative.vouchers.order(reference_number: :desc, date: :desc).text_search(params[:search]).paginate(page: params[:page], per_page: 50)
                else
                  current_cooperative.vouchers.includes(:payee).order(reference_number: :desc, date: :desc).paginate(page: params[:page], per_page: 50)
                end
  end

  def show
    @voucher = current_cooperative.vouchers.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = VoucherPdf.new(
          voucher: @voucher,
          view_context: view_context
        )
        send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Voucher.pdf'
      end
    end
  end

  def destroy
    @voucher = current_cooperative.vouchers.find(params[:id])
    if @voucher.disbursed?
      redirect_to '/', alert: 'Cannot delete voucher. Already disbursed.'
    else
      @voucher.destroy
      redirect_to '/', notice: 'Voucher cancelled successfully.'
    end
  end
end
