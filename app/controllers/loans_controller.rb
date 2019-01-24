class LoansController < ApplicationController
  def index
    if params[:from_date].present? && params[:to_date].present?
      @from_date = DateTime.parse(params[:from_date])
      @to_date = DateTime.parse(params[:to_date])
      @loans = current_cooperative.loans.not_cancelled.not_archived.past_due_loans(from_date: @from_date, to_date: @to_date).paginate(:page => params[:page], :per_page => 20)
    elsif params[:search].present?
      @loans = current_cooperative.loans.not_cancelled.not_archived.text_search(params[:search]).paginate(page: params[:page], per_page: 20)
    else
      @loans = current_cooperative.loans.
      # includes(:disbursement_voucher, borrower: [:avatar_attachment], loan_product: [:current_account, :past_due_account]).
      not_archived.
      order(updated_at: :desc).
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
    @loan = current_cooperative.loans.includes(:loan_co_makers =>[:co_maker]).find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = StatementOfAccounts::LoanPdf.new(
        loan:         @loan,
        view_context: view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Statement of Account.pdf"
      end
    end
  end
end
