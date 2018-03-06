module Members
  class LoansController < ApplicationController
    def index
      @member = Member.find(params[:member_id])
      @loans = @member.loans
    end
    def new
      @member = Member.friendly.find(params[:member_id])
      @loan = @member.loans.build
    end
    def create
    end
  end
end
