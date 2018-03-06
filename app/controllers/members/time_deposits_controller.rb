module Members
  class TimeDepositsController < ApplicationController
    def index
      @member = Member.find(params[:member_id])
      @time_deposits = @member.time_deposits
    end
  end
end
