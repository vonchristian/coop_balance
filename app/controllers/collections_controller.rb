class CollectionsController < ApplicationController
  def index 
    @employees = User.all
    @entries = AccountingModule::Account.find_by(name: "Cash on Hand (Treasury)").debit_entries.paginate(page: params[:page], per_page: 30)
    @employee = User.find_by(id: params[:recorder_id])
    respond_to do |format| 
      format.html
      format.pdf do 
        pdf = AccountingModule::CollectionReportPdf.new(@entries, @employee, view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Collection Report.pdf"
      end
    end 
  end 
end 