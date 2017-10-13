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
    @loan = @voucher.voucherable
    respond_to do |format| 
      format.html 
      format.pdf do 
        if @voucher.for_employee? || @voucher.for_purchases?
          pdf = VoucherPdf.new(@voucher, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Voucher.pdf"
        elsif @voucher.for_loan?   
          pdf = LoansModule::LoanDisbursementVoucherPdf.new(@loan, @voucher, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Voucher.pdf"
        end
      end 
    end
  end
end 