module Loans
  class SettingsController < ApplicationController
    def index
      @loan = current_cooperative.loans.find(params[:loan_id])
    end
  end
end
