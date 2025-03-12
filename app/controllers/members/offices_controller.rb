module Members
  class OfficesController < ApplicationController
    respond_to :html, :json

    def edit
      @member = current_cooperative.member_memberships.find(params[:member_id])
      respond_modal_with @contact
    end

    def update
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @office = @member.update(office_params)
      respond_modal_with @office,
                         location: member_info_index_url(@member)
    end

    private

    def office_params
      params.require(:member).permit(:office_id)
    end
  end
end
