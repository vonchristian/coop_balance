module LoansModule
  class MaturedLoansController < ApplicationController
    def index
      @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Date.today.to_date
      @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.to_date
      @loans = LoansModule::Loan.past_due(from_date: @from_date, to_date: @to_date).paginate(page: params[:page], per_page: 25)
    end
  end
end

