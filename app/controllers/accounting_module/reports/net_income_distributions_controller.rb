module AccountingModule
  module Reports
    class NetIncomeDistributionsController < ApplicationController
      def index
        @cooperative = current_cooperative
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :desc).first.try(:entry_date)
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today
        @net_income = current_cooperative.accounts.net_surplus(from_date: @from_date, to_date: @to_date)
        @net_income_distributions = current_cooperative.net_income_distributions
        respond_to do |format|
          format.html
          format.pdf do
            pdf = AccountingModule::Reports::NetIncomeDistributionPdf.new(
              from_date:      @from_date,
              to_date:      @to_date,
              accounts:     @accounts,
              employee:     current_user,
              net_income:    @net_income,
              net_income_distributions: @net_income_distributions,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Net Income Distribution Report.pdf"
          end
        end
      end
    end
  end
end
