class VouchersController < ApplicationController
  def index
    if params[:search].present?
      @vouchers = current_cooperative.vouchers.order(reference_number: :desc).text_search(params[:search]).paginate(page: params[:page], per_page: 50)
    else
      @vouchers = current_cooperative.vouchers.includes(:payee).all.order(reference_number: :desc).order(date: :desc).paginate(page: params[:page], per_page: 50)
    end
  end
  def show
    @voucher = current_cooperative.vouchers.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = VoucherPdf.new(
          voucher: @voucher,
          view_context: view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Voucher.pdf"
      end
    end
  end
  def destroy
    @voucher = current_cooperative.vouchers.find(params[:id])
    if !@voucher.disbursed?
      @voucher.destroy
      redirect_to "/", notice: "Voucher cancelled successfully."
    else
      redirect_to "/", alert: "Cannot delete voucher. Already disbursed."
    end
  end
end
