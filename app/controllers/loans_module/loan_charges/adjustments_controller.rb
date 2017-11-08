module LoansModule
	module LoanCharges
		class AdjustmentsController < ApplicationController
			def new
				@loan_charge = LoansModule::LoanCharge.find(params[:loan_charge_id])
        @loan = @loan_charge.loan
				@adjustment = @loan_charge.build_charge_adjustment
			end
			def create
				@loan_charge = LoansModule::LoanCharge.find(params[:loan_charge_id])
        @loan = @loan_charge.loan
				@adjustment = @loan_charge.build_charge_adjustment(charge_adjustment_params)
				if @adjustment.valid?
					@adjustment.save
					redirect_to loans_module_loan_application_url(@loan_charge.loan), notice: "Adjustment saved successfully."
          # @loan_charge.loan.create_amortization_schedule
				else
					render :new
				end
			end
			private
			def charge_adjustment_params
				params.require(:loans_module_charge_adjustment).permit(:percent, :amount, :amortize_balance)
			end
		end
	end
end
