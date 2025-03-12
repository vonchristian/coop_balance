module LoansModule
  class OrganizationsController < ApplicationController
    def index
      @organizations = if params[:search].present?
                         current_cooperative.organizations.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
      else
                         current_cooperative.organizations.order(:abbreviated_name).paginate(page: params[:page], per_page: 25)
      end
    end

    def show
      @organization = current_cooperative.organizations.find(params[:id])
    end
  end
end
