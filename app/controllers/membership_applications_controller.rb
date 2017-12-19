class MembershipApplicationsController < ApplicationController
  def new
    @membership = MembershipApplicationForm.new
  end
  def create
    @membership = MembershipApplicationForm.new(membership_params)
    if @membership.valid?
      @membership.save
      redirect_to new_membership_application_contribution_url(@membership.find_member), notice: "Membership application saved successfully"
       CoopServicesModule::Program.subscribe(@membership.find_member)
    else
      render :new
    end
  end
  def show
    @membership = Member.find(params[:id])
  end

  private
  def membership_params
    params.require(:membership_application_form).permit(:first_name, :middle_name, :last_name,
      :date_of_birth,
      :account_number,
      :pmes_date,
      :membership_type,
      :place_of_birth,
      :address,
      :civil_status,
      :sex,
      :contact_number,
      :email,
      :educational_attainment,
      :employer_address,
      :father_first_name,
      :father_middle_name,
      :father_last_name,
      :father_occupation,
      :father_address,
      :mother_first_name,
      :mother_middle_name,
      :mother_maiden_name,
      :mother_occupation,
      :mother_address,
      :spouse_first_name,
      :spouse_middle_name,
      :spouse_last_name,
      :spouses_occupation,
      :spouses_date_of_birth,
      :spouse_educational_attainment,
      :spouses_occupation,
      :application_date,
      :share_capital_product_id,
      :membership_type,
      :office_id )
      end
end
