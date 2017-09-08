module LoansModule 
  class FirstNoticesController < ApplicationController 
    def new 
      @loan = LoansModule::Loan.find(params[:loan_id])
      respond_to do |format|
        format.pdf do 
          pdf = LoansModule::FirstNoticePdf.new(@loan,view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Loan Disbursement Voucher.pdf"
        end 
      end 
    end 
  end 
end