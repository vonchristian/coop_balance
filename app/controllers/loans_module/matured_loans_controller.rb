module LoansModule
  class MaturedLoansController < ApplicationController
    def index
      @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Date.today.to_date
      @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.to_date
      @loans = current_cooperative.loans.past_due_loans(from_date: @from_date, to_date: @to_date).paginate(page: params[:page], per_page: 25)
      respond_to do |format|
        format.html
        format.xlsx
      end
    end
  end
end
