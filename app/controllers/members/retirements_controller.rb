module Members
  class RetirementsController < ApplicationController
    respond_to :html, :json

    def edit
      @member = current_cooperative.member_memberships.find(params[:id])
      respond_modal_with @member
    end

    def update
      @member = current_cooperative.member_memberships.find(params[:id])
      @member.update(retirement_params)
      respond_modal_with @member, location: member_settings_url(@member)
    end

    private

    def retirement_params
      params.require(:member).permit(:retired_at)
    end
  end
end