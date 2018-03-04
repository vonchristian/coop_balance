module Members
  class TimeDepositsController < ApplicationController
    def index
      @member = Member.friendly.find(params[:member_id])
      @time_deposits = @member.time_deposits
    end
  end
end
