module LoansModule
  module Organizations
    class LoansController < ApplicationController
      def index
        @organization = current_cooperative.organizations.find(params[:organization_id])
        @loans = @organization.member_loans.paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
