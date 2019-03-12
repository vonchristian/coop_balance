class LoansController < ApplicationController
  def index
    if params[:from_date].present? && params[:to_date].present?
      @from_date = DateTime.parse(params[:from_date])
      @to_date = DateTime.parse(params[:to_date])
      @loans = current_cooperative.loans.not_cancelled.not_archived.past_due_loans(from_date: @from_date, to_date: @to_date).paginate(:page => params[:page], :per_page => 20)
    elsif params[:search].present?
      @loans = current_cooperative.loans.not_cancelled.not_archived.text_search(params[:search]).paginate(page: params[:page], per_page: 20)
    else
      @loans = current_cooperative.loans.includes(:borrower).
      # includes(:disbursement_voucher, borrower: [:avatar_attachment], loan_product: [:current_account, :past_due_account]).
      not_cancelled.
      not_archived.
      order(updated_at: :desc).
      paginate(page: params[:page], per_page: 30)
    end
    @amortization_schedules = current_office.amortization_schedules.includes(:loan).scheduled_for(from_date: Date.current.beginning_of_month, to_date: Date.current.next_month.end_of_month).paginate(page: params[:page], per_page: 25)
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
    @loan = current_cooperative.loans.merge(Member.with_attached_avatar).find(params[:id])
    @loan_co_makers = @loan.loan_co_makers
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
