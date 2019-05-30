module SavingsAccounts
  class TransactionsController < ApplicationController
    
    def index
      @savings_account = current_cooperative.savings.find(params[:savings_account_id])
      @entries_pdf = @savings_account.entries.order(:entry_date).includes(:commercial_document, :recorder, :cooperative_service).distinct
      @entries = @entries_pdf.paginate(:page => params[:page], :per_page => 20)
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Members::SavingsAccountLedgerPdf.new(
          entries: @entries_pdf,
          savings_account: @savings_account,
          view_context:    view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Statement of Account.pdf"
        end
      end
    end
  end
end