module LoansModule
  class OrganizationsController < ApplicationController
    def index
			if params[:search].present?
	      @organizations = current_cooperative.organizations.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
	    else
	      @organizations = current_cooperative.organizations.order(:abbreviated_name).paginate(page: params[:page], per_page: 25)
	    end
    end
    def show
      @organization = current_cooperative.organizations.find(params[:id])
    end
  end
end
