module Members
  class CreditScoresController < ApplicationController
    def index
      @member = Member.find(params[:member_id])
    end
  end
end 
