module LoansModule
  module Loans
    class ShareCapitalBuildUpsController < ApplicationController
      def new
        @loan = LoansModule::Loan.find(params[:loan_id])
        @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
        @capital_build_up = LoansModule::Loans::ShareCapitalBuildUp.new
      end
      def create
        @loan = LoansModule::Loan.find(params[:loan_id])
        @share_capital = MembershipsModule::ShareCapital.find(params[:loans_module_loans_share_capital_build_up][:share_capital_id])
        @capital_build_up = LoansModule::Loans::ShareCapitalBuildUp.new(capital_build_up_params)
        if @capital_build_up.valid?
          @capital_build_up.add_to_loan_charges!
          redirect_to loans_module_loan_application_url(@loan), notice: "Capital Build Up added successfully"
        else
          render :new
        end
      end

      private
      def capital_build_up_params
        params.require(:loans_module_loans_share_capital_build_up).
        permit(:amount, :employee_id, :loan_id, :share_capital_id)
      end
    end
  end
end
