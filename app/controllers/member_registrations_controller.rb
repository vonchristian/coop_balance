class MemberRegistrationsController < ApplicationController
  def new
    @member = MemberRegistrationForm.new
  end

  def create
    @member = MemberRegistrationForm.new(member_params)
    if @member.valid?
      @member.save
      redirect_to management_module_members_url, notice: "Member registered successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def member_params
    params.require(:member_registration_form).permit(:first_name,
                                                     :middle_name,
                                                     :last_name,
                                                     :sex,
                                                     :avatar,
                                                     :date_of_birth,
                                                     :tin_number)
  end
end
