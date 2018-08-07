module LoansModule
	module LoanCharges
		class AdjustmentsController < ApplicationController
			def new
				@loan_charge = LoansModule::LoanCharge.find(params[:loan_charge_id])
        @loan = @loan_charge.loan
				@adjustment = LoansModule::Loans::AdjustmentProcessing.new
			end
			def create
				@loan_charge = LoansModule::LoanCharge.find(params[:loan_charge_id])
        @loan = @loan_charge.loan
				@adjustment = LoansModule::Loans::AdjustmentProcessing.new(charge_adjustment_params)
				if @adjustment.valid?
					@adjustment.save
					redirect_to loans_module_loan_application_url(@loan_charge.loan), notice: "Adjustment saved successfully."
				else
					render :new
				end
			end
			private
			def charge_adjustment_params
				params.require(:loans_module_loans_adjustment_processing).permit(:loan_id, :loan_charge_id, :percent, :amount, :amortize_balance, :number_of_payments, :employee_id)
			end
		end
	end
end
