module Members
  class SavingsAccountsController < ApplicationController
    def index
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @savings = @member.savings
    end
  end
end
