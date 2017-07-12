module LoansModule
  class LoansController < ApplicationController
    def index
      @loans = LoansModule::Loan.all
    end
    def show
      @loan = LoansModule::Loan.find(params[:id])
    end
  end
end
