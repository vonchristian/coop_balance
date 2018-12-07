module Members
  class LoansController < ApplicationController
    def index
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @loans = @member.loans
	    @loan_products = current_cooperative.loan_products
	    @loan_types = LoansModule::LoanProduct.loan_types.keys.to_a
    end
  end
end
