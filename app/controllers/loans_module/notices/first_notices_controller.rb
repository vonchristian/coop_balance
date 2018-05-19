module LoansModule
  module Notices
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

      def show
        @loan = LoansModule::Loan.find(params[:loan_id])
        @notice = @loan.notices.first_notice
        respond_to do |format|
          format.html
          format.pdf do
            pdf = LoansModule::Notices::FirstNoticePdf.new(@loan, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "First Notice.pdf"
          end
        end
      end
    end
  end
end
