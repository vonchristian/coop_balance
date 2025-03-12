module LoansModule
  module Loans
    class InterestRebatePostingsController < ApplicationController
      def new
        @loan = current_cooperative.loans.find(params[:loan_id])
        @rebate = LoansModule::Loans::InterestRebatePosting.new
      end

      def create
        @loan = current_cooperative.loans.find(params[:loan_id])
        @rebate = LoansModule::Loans::InterestRebatePosting.new(rebate_params)
        if @rebate.valid?
          @rebate.save
          redirect_to loan_url(@loan), notice: "Rebate saved successfully"
        else
          render :new, status: :unprocessable_entity
        end
      end

      private

      def rebate_params
        params.require(:loans_module_loans_interest_rebate_posting)
              .permit(:date, :reference_number, :description, :amount, :employee_id, :loan_id)
      end
    end
  end
end
