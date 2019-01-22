module Organizations
  class LoansController < ApplicationController
    def index
      @organization = current_cooperative.organizations.find(params[:organization_id])
      @loans = @organization.member_loans.disbursed.unpaid.paginate(page: params[:page], per_page: 50)
    end
  end
end
