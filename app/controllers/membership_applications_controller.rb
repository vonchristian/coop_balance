class MembershipApplicationsController < ApplicationController
  def new
    @membership = MembershipApplication.new
  end

  def create
    @membership = MembershipApplication.new(membership_params)
    if @membership.valid?
      @membership.register!
      redirect_to member_url(@membership.find_member), notice: "Member information saved successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def membership_params
    params.require(:membership_application).permit(
      :first_name,
      :middle_name,
      :last_name,
      :avatar,
      :date_of_birth,
      :account_number,
      :membership_category_id,
      :civil_status,
      :sex,
      :contact_number,
      :email,
      :tin_number,
      :office_id,
      :cooperative_id,
      :membership_date,
      :complete_address,
      :barangay_id,
      :municipality_id,
      :province_id
    )
  end
end
