module LoansModule	
	class LoanCharge < ApplicationRecord
	  belongs_to :loan, class_name: "LoansModule::Loan"
	  belongs_to :charge
	end
end