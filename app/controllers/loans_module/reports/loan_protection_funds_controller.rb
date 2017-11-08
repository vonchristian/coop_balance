module LoansModule
  module Reports
    class LoanProtectionFundsController < ApplicationController
      def index
        @loan_protection_funds = LoansModule::LoanProtectionFund.all
        respond_to do |format|
          format.html
          format.pdf do
            pdf = LoansModule::Reports::LoanProtectionFundPdf.new(@loan_protection_funds)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Loan Protection Fund PDF.pdf"
          end
        end
      end
    end
  end
end
