module Members
  class SavingsAccountsController < ApplicationController
    def index
      @member = current_office.member_memberships.find(params[:member_id])
      @savings = @member.savings.includes(:saving_product, :office, :liability_account)
    end
  end
end
