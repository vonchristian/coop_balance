module LoansModule
	class LoanApproval < ApplicationRecord
	  belongs_to :approver, class_name: "User", foreign_key: 'approver_id'
	  belongs_to :loan, class_name: "LoansModule::Loan"
	end
end