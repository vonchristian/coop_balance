module LoansModule
	class LoanCoMakersController < ApplicationController
		def new 
			@loan = LoansModule::Loan.find(params[:loan_id])
			@co_maker = @loan.loan_co_makers.build 
		end 
		def create
			@loan = LoansModule::Loan.find(params[:loan_id])
			@co_maker = @loan.loan_co_makers.create(co_maker_params)
			if @co_maker.valid?
				@co_maker.save
				redirect_to new_loans_module_loan_loan_co_maker_url(@loan), notice: "Co Maker saved successfully."
			else 
				render :new 
			end 
		end 

		private 
	  def co_maker_params
	  	params.require(:loans_module_loan_co_maker).permit(:co_maker_id)
		end 
	end
end