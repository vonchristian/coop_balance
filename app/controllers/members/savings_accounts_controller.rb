module Members
  class SavingsAccountsController < ApplicationController
    def index
      @member = Member.find(params[:member_id])
      @savings = @member.savings
    end
  end
end
