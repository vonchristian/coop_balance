module LoansModule
  module Loans
    class LossesController < ApplicationController
    	respond_to :html, :json

      def new
        @loan = current_cooperative.loans.find(params[:loan_id])
        @loss = LoansModule::Loans::LossProcessing.new
        respond_modal_with @loss
      end
    end
  end
end
