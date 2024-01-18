module Members
  class LoanTransactionsController < ApplicationController
    def index
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @loan_product = LoansModule::LoanProduct.find(params[:loan_product_id])
      @forwarded_loans = @member.loans_for(loan_product: @loan_product).forwarded_loans
      @applied_loan_products = @member.applied_loan_products
      @transactions = @member.loans_for(loan_product: @loan_product).loan_transactions.paginate(page: params[:page], per_page: 15)
      @entries = @member.loans_for(loan_product: @loan_product).loan_transactions
      @title = @loan_product.name.downcase.include?('short-term') ? 'Short-Term Loan' : @loan_product.name
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Members::LoansLedgerPdf.new(
            entries: @entries,
            forwarded_loans: @forwarded_loans,
            member: @member,
            loan_product: @loan_product,
            title: @title,
            cooperative: current_cooperative,
            view_context: view_context
          )
          send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Amortization Schedule.pdf'
        end
      end
    end
  end
end