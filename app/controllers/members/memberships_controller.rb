module Members
  class MembershipsController < ApplicationController
    def new
      @member = Member.find(params[:member_id])
      @membership = @member.build_membership
    end

    def create
       @member = Member.find(params[:member_id])
      @membership = @member.create_membership(membership_params)
      if @membership.valid?
        @membership.save
        redirect_to member_url(@member), notice: "Membership saved successfully."
      else
        render :new
      end
    end

    def edit
      @member = Member.find(params[:member_id])
      @membership = @member.membership
    end
    def update
       @member = Member.find(params[:member_id])
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
      params.require(:membership).permit(:membership_type, :account_number)
    end
  end
end
