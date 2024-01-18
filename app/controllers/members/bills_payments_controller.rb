module Members
  class BillsPaymentsController < ApplicationController
    def index
      @member = current_cooperative.member_memberships.find(params[:member_id])
    end
  end
end
