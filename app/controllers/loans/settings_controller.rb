module Loans
  class SettingsController < ApplicationController
    def index
      @loan = LoansModule::Loan.find(params[:loan_id])
    end
  end
end
