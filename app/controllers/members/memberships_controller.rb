module Members
  class MembershipsController < ApplicationController
    def new
      @member = Member.find(params[:member_id])
      @membership = @member.memberships.build
    end

    def create
       @member = Member.find(params[:member_id])
      @membership = @member.memberships.create(membership_params)
      if @membership.valid?
        @membership.save
        redirect_to member_settings_url(@member), notice: "Membership saved successfully."
      else
        render :new
      end
    end

    def edit
      @member = Member.find(params[:member_id])
      @membership = Membership.where(cooperative_id: params[:cooperative_id]).last
    end

    def update
      @member = Member.find(params[:member_id])
      @membership = Membership.find(params[:id])
      @membership.update(membership_params)
      if @membership.valid?
        @membership.save
        redirect_to member_settings_url(@member), notice: "Membership updated successfully."
      else
        render :new
      end
    end

    private
    def membership_params
      params.require(:membership).permit(:membership_type, :account_number, :cooperative_id, :membership_date)
    end
  end
end
