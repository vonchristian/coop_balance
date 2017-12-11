module AccountingModule
  module Reports
    class TrialBalancesController < ApplicationController
      def index
        @from_date = params[:from_date] ? Chronic.parse(params[:from_date]) : Date.today.at_beginning_of_month
        @to_date = params[:to_date] ? Chronic.parse(params[:to_date]) : Date.today
        @accounts = AccountingModule::Account.all.paginate(page: params[:page], per_page: 50)
        respond_to do |format|
          format.html
          format.xlsx
          format.pdf do
            pdf = AccountingModule::Reports::TrialBalancesPdf.new(@accounts, @to_date, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Trial Balance.pdf"
          end
        end
      end
    end
  end
end
