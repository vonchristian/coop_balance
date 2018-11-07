module Members
  class OfficesController < ApplicationController
    def edit
      @member = current_cooperative.member_memberships.find(params[:member_id])
    end
    def update
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @member.update(office_params)
      if @member.save
        redirect_to member_url(@member), notice: "Office updated successfully"
      else
        render :edit
      end
    end
    private
    def office_params
      params.require(:member).permit(:office_id)
    end
  end
end

