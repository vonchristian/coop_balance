module LoansModule
  module Loans
    class PastDuesController < ApplicationController
      respond_to :html, :json
      def new
        @loan = current_cooperative.loans.find(params[:loan_id])
        @past_due = LoansModule::Loans::PastDueProcessing.new
        respond_modal_with @past_due
      end
    end
  end
end
