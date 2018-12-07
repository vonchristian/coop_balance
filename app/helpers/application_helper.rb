module ApplicationHelper

	def loan_types
		LoansModule::LoanProduct.loan_types.keys.to_a.map {|l| [l.titleize, l]}
	end
  
end
