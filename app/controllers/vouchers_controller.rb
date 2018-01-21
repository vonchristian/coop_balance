class VouchersController < ApplicationController
  def index
    if params[:search].present?
      @vouchers = Voucher.text_search(params[:search]).paginate(page: params[:page], per_page: 50)
    else
      @vouchers = Voucher.all.order(date: :desc).paginate(page: params[:page], per_page: 50)
    end
  end
  def show
    @voucher = Voucher.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = VoucherPdf.new(@voucher, view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Voucher.pdf"
      end
    end
  end
  def destroy
    @voucher = Voucher.find(params[:id])
    @voucher.destroy
    redirect_to "/", notice: "Voucher cancelled successfully."
  end
end
