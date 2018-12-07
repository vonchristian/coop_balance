module Members
  class LoansController < ApplicationController
    def index
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @loans = @member.loans
	    @loan_products = current_cooperative.loan_products
    end
  end
end
