module LoansModule
  class LoanPaymentsController < ApplicationController
    def show 
      @entry = current_office.entries.find(params[:id])
      account_ids = @entry.amounts.pluck(:account_id)
      loan_ids = []
      loan_ids << current_office.loans.where(receivable_account_id: account_ids.compact.flatten.uniq)
      loan_ids << current_office.loans.where(interest_revenue_account_id: account_ids.compact.flatten.uniq)
      loan_ids << current_office.loans.where(penalty_revenue_account_id: account_ids.compact.flatten.uniq)
      @pagy, @loans = pagy(current_office.loans.where(id: loan_ids.compact.uniq.flatten))
    end 
  end 
end 
