module LoansModule
  class OrganizationsController < ApplicationController
    def index
      @organizations = current_cooperative.organizations.paginate(page: params[:page], per_page: 25)
    end
    def show
      @organization = current_cooperative.organizations.find(params[:id])
    end
  end
end
