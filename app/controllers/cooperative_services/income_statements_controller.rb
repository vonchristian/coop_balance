module CooperativeServices
  class IncomeStatementsController < ApplicationController
    def index
      @cooperative_service = current_cooperative.cooperative_services.find(params[:cooperative_service_id])
      @accounts = @cooperative_service.accounts
      @from_date = params[:from_date] ? Date.parse(params[:from_date]) : Date.today
      @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Date.today
      respond_to do |format|
        format.html
        format.pdf do
          pdf = CooperativeServices::IncomeStatementPdf.new(
            from_date: @from_date,
            to_date: @to_date,
            cooperative_service: @cooperative_service,
            accounts: @accounts,
            view_context: view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "#{@cooperative_service.title}.pdf"
        end
      end

    end
  end
end
