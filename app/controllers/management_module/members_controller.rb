module ManagementModule
  class MembersController < ApplicationController
    def index
      @members = if params[:search].present?
                   current_cooperative.member_memberships.text_search(params[:search]).order(:last_name)
                 else
                   current_cooperative.member_memberships.order(:last_name)
                 end
    end

    def show
      @member = current_cooperative.member_memberships.find(params[:id])
    end
  end
end
