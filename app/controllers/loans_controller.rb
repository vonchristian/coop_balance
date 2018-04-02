class LoansController < ApplicationController
  def index
    if params[:search].present?
      @loans = LoansModule::Loan.text_search(params[:search]).paginate(page: params[:page], per_page: 30)
    else
      @loans = LoansModule::Loan.
      all.
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
