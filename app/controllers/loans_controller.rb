class LoansController < ApplicationController
  def index
    if params[:search].present?
      @pagy, @loans = pagy(current_office.loans.not_cancelled.not_archived.unpaid.text_search(params[:search]))
    else
      @pagy, @loans = pagy(current_office.loans.not_cancelled.not_archived.unpaid.includes(:term, :loan_product, :borrower, :receivable_account).
      # includes(:disbursement_voucher, borrower: [:avatar_attachment], loan_product: [:current_account, :past_due_account]).
      not_cancelled.
      not_archived.
      order(updated_at: :desc))
    end
    @offices = current_cooperative.offices
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
    @loan                          = current_office.loans.merge(Member.with_attached_avatar).find(params[:id])
    @pagy, @amortization_schedules = pagy(@loan.amortization_schedules.order(date: :asc))
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
