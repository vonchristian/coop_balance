module Members
  class LoansController < ApplicationController
    def index
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @loans = @member.loans
    end
  end
end
