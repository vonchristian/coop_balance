module ManagementModule
  class MembersController < ApplicationController
    def index
      if params[:search].present?
        @members = current_cooperative.member_memberships.text_search(params[:search]).order(:last_name)
      else
        @members = current_cooperative.member_memberships.order(:last_name)
      end
    end
    def show
      @member = current_cooperative.member_memberships.find(params[:id])
    end
  end
end
