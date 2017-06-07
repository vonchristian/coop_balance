class MemberRegistrationsController < ApplicationController
  def new
    @member = MemberForm.new(Member.new)
  end
  def create
    @member = MemberForm.new(Member.new)
    if @member.validate(params[:member])
      @member.save
      redirect_to new_member_address_detail_path(@member), notice: "Loan Product created successfully."
    else
      render :new
    end
  end
end
