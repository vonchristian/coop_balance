module LoansModule
  module Loans
    class LossesController < ApplicationController
      respond_to :html, :json

      def new
        @loan = current_cooperative.loans.find(params[:loan_id])
        @loss = LoansModule::Loans::LossProcessing.new
        respond_modal_with @loss
      end

      def create
        @loan = current_cooperative.loans.find(params[:loan_id])
        @loss = LoansModule::Loans::LossProcessing.new(loan_loss_params)
        respond_modal_with @loss,
                           location: loans_module_loan_loss_voucher_url(id: @loan.id),
                           notice: 'saved successfully'
      end

      private

      def loan_loss_params
        params.require(:loans_module_loans_loss_processing)
              .permit(:loan_id, :date, :description, :reference_number)
      end
    end
  end
end
