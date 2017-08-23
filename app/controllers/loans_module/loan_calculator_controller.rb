module LoansModule
	class LoanCalculatorController < ApplicationController
		def index 
      @loan = LoanApplicationForm.new
		end 
	end 
end