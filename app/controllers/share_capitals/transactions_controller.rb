module ShareCapitals
  class TransactionsController < ApplicationController
    def index
      @share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      @entries_pdf = @share_capital.entries.order(:entry_date).includes(:commercial_document, :recorder, :cooperative_service).distinct
      @entries = @entries_pdf.paginate(page: params[:page], per_page: 20)
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Members::ShareCapitalLedgerPdf.new(
            entries: @entries_pdf,
            share_capital: @share_capital,
            view_context: view_context
          )
          send_data pdf.render, type: "application/pdf", disposition: "inline", file_name: "Statement of Account.pdf"
        end
      end
    end
  end
end
