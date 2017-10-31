module Members
  class MembershipsController < ApplicationController
    def edit
      @member = Member.friendly.find(params[:member_id])
      @membership = @member.membership
    end
    def update
       @member = Member.friendly.find(params[:member_id])
      @membership = @member.create_membership(membership_params)
      if @membership.valid?
        @membership.save
        redirect_to member_url(@member), notice: "Membership saved successfully."
      else
        render :new
      end
    end

    private
    def membership_params
      params.require(:membership).permit(:membership_type)
    end
  end
end
