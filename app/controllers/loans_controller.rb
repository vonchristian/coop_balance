class LoansController < ApplicationController
  def index
    if params[:loan_product].present? && params[:barangay].blank?
      @loans = LoansModule::LoanProduct.find(params[:loan_product]).loans
    elsif params[:loan_product].present? && params[:barangay].present?
      @barangay = Barangay.find(params[:barangay])
      @loans = LoansModule::LoanProduct.find(params[:loan_product]).loans.where(barangay: @barangay)
    elsif params[:search].present?
      @loans = LoansModule::Loan.text_search(params[:search]).paginate(page: params[:page], per_page: 30)
    elsif params[:barangay].present?
      @barangay = Barangay.find(params[:barangay])
      @loans = @barangay.loans.paginate(page: params[:page], per_page: 30)
    else
      @loans = LoansModule::Loan.all.paginate(page: params[:page], per_page: 30)
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
