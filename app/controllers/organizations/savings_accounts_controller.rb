module Organizations
  class SavingsAccountsController < ApplicationController
    def index
      @organization = current_cooperative.organizations.find(params[:organization_id])
    end
  end
end
