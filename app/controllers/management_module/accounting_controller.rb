module ManagementModule
	class AccountingController < ApplicationController
		def index
		  @employees = Department.find_by(name: "Accounting").employees 
		end 
	end 
end 