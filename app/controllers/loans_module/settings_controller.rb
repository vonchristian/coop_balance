module LoansModule 
	class SettingsController < ApplicationController
		def index 
			@charges = Charge.all
      @loan_protection_rates = LoanProtectionRate.all 
		end 
	end 
end 