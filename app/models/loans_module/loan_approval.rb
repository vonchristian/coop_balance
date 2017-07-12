module LoansModule
	class LoanApproval < ApplicationRecord
	  belongs_to :approver, class_name: "User"
	  belongs_to :loan, class_name: "LoansModule::Loan"
	end
end