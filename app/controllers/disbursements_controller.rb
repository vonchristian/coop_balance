class DisbursementsController < ApplicationController 
  def index
    @employees = User.all
    @entries = AccountingModule::Account.find_by(name: "Cash on Hand (Treasury)").credit_entries
    @employee = User.find_by(id: params[:recorder_id])
    respond_to do |format| 
      format.html
      format.pdf do 
        pdf = AccountingModule::DisbursementReportPdf.new(@entries, @employee, view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Disbursement.pdf"
      end
    end 
  end

  def new 
    @entry = AccountingModule::EntryForm.new
  end 

  def create 
    @entry = AccountingModule::EntryForm.new(entry_params)
    if @entry.valid?
      @entry.save 
      redirect_to disbursements_url, notice: "Disbursement saved successfully"
    else 
      render :new 
    end 
  end 

  private 
  def entry_params
    params.require(:accounting_module_entry_form).permit(:user_id, :amount, :debit_account_id, :credit_account_id, :entry_date, :description, :reference_number, :entry_type)
  end
end 