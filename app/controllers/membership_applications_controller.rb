class MembershipApplicationsController < ApplicationController
  def new
    @membership = MembershipApplication.new
  end
  def create
    @membership = MembershipApplication.new(membership_params)
    if @membership.valid?
      @membership.save
      redirect_to member_url(id: @membership.find_member.id), notice: "Member information saved successfully"
    else
      render :new
    end
  end


  private
  def membership_params
    params.require(:membership_application).permit(:first_name, :middle_name, :last_name,
      :date_of_birth,
      :account_number,
      :membership_type,
      :civil_status,
      :sex,
      :contact_number,
      :email,
      :tin_number,
      :office_id,
      :cooperative_id )
  end
end
