class LoansController < ApplicationController
  def index
    if params[:from_date].present? && params[:to_date].present?
      @from_date = DateTime.parse(params[:from_date])
      @to_date = DateTime.parse(params[:to_date])
      @loans = current_cooperative.loans.disbursed.not_archived.past_due(from_date: @from_date, to_date: @to_date).paginate(:page => params[:page], :per_page => 20)
    elsif params[:search].present?
      @loans = current_cooperative.loans.text_search(params[:search]).paginate(page: params[:page], per_page: 20)
    else
      @loans = current_cooperative.loans.
      disbursed.
      not_archived.
      order(updated_at: :desc).
      includes(:borrower, :loan_product => [:loans_receivable_current_account => [:subsidiary_accounts]]).
      paginate(page: params[:page], per_page: 30)
    end
    respond_to do |format|
      format.xlsx
      format.html
      format.pdf do
        pdf = LoansModule::Reports::FilteredLoansPdf.new(@loans,view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Loans Report.pdf"
      end
    end
  end

  def show
    @loan = LoansModule::Loan.find(params[:id])
  end
end
