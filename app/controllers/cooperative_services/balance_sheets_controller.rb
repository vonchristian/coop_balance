module CooperativeServices
  class BalanceSheetsController < ApplicationController
    def index
      @cooperative_service = current_cooperative.cooperative_services.find(params[:cooperative_service_id])
      @assets = @cooperative_service.accounts.assets.active.uniq
      @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Date.today
      respond_to do |format|
        format.html
        format.pdf do
          pdf = AccountingModule::Reports::BalanceSheetPdf2.new(to_date: @to_date, cooperative_service: @cooperative_service, assets: @assets, view_context: view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "#{@cooperative_service.title}.pdf"
        end
      end
    end
  end
end
