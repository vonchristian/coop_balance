module LoansModule
  module Loans
    class TrackingNumbersController < ApplicationController
      respond_to :html, :json

      def edit
        @loan = current_cooperative.loans.find(params[:loan_id])
        @tracking_number = LoansModule::Loans::TrackingNumberProcessing.new
        respond_modal_with @tracking_number
      end

      def update
        @loan = current_cooperative.loans.find(params[:loan_id])
        @tracking_number = LoansModule::Loans::TrackingNumberProcessing.new(tracking_number_params)
        @tracking_number.save
        respond_modal_with @tracking_number, location: loan_settings_url(@loan)
      end

      private

      def tracking_number_params
        params.require(:loans_module_loan).permit(:tracking_number, :loan_id)
      end
    end
  end
end
