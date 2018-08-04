module LoansModule
  module Loans
    class TrackingNumbersController < ApplicationController
      def edit
        @loan = LoansModule::Loan.find(params[:loan_id])
        @tracking_number = LoansModule::Loans::TrackingNumberProcessing.new
      end

      def update
        @loan = LoansModule::Loan.find(params[:loan_id])
        @tracking_number = LoansModule::Loans::TrackingNumberProcessing.new(tracking_number_params)
        if @tracking_number.valid?
          @tracking_number.save
          redirect_to loan_url(@loan), notice: "Loan tracking number saved successfully."
        else
          render :new
        end
      end

      private
      def tracking_number_params
        params.require(:loans_module_loan).
        permit(:tracking_number, :loan_id)
      end
    end
  end
end
