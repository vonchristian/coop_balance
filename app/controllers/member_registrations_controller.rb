class MemberRegistrationsController < ApplicationController
  def new
    @member = MemberForm.new(Member.new)
  end
  def create
    @member = MemberForm.new(Member.new)
    if @member.validate(params[:member])
      @member.save
      redirect_to loans_department_loan_products_url, notice: "Loan Product created successfully."
    else
      render :new
    end
  end
end
