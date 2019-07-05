module AccountingModule
  module CooperativeServices
    class EntriesController < ApplicationController
      def index
        @cooperative_service = current_cooperative.cooperative_services.find(params[:cooperative_service_id])
        if params[:from_date] && params[:to_date]
          @from_date = Date.parse(params[:from_date])
          @to_date   = Date.parse(params[:to_date])
          @pagy, @entries = pagy(@cooperative_service.entries.entered_on(from_date: @from_date, to_date: @to_date))
          @entries_for_pdf = @cooperative_service.entries.entered_on(from_date: @from_date, to_date: @to_date)
        else
          @pagy, @entries      = pagy(@cooperative_service.entries)
          @entries_for_pdf     = @cooperative_service.entries
        end
        respond_to do |format|
          format.html
          format.pdf do
            pdf = AccountingModule::EntriesPdf.new(
              from_date:    @from_date,
              to_date:      @to_date,
              entries:      @entries_for_pdf,
              cooperative_service: @cooperative_service,
              organization: @organization,
              employee:     current_user,
              cooperative:  current_cooperative,
              title:        "Journal Entries",
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Entries report.pdf"
          end
        end
      end
    end
  end
end
