module LoansModule
	class LoanApproval < ApplicationRecord
	  belongs_to :approver, class_name: "User"
	  belongs_to :loan
	end
end