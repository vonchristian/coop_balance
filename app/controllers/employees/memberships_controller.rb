module Employees
  class MembershipsController < ApplicationController
    def new
      @employee = User.find(params[:employee_id])
      @membership = @employee.build_membership
    end

    def create
       @employee = User.find(params[:employee_id])
      @membership = @employee.create_membership(membership_params)
      if @membership.valid?
        @membership.save
        redirect_to employee_url(@employee), notice: "Membership saved successfully."
      else
        render :new
      end
    end

    def edit
      @employee = User.find(params[:employee_id])
      @membership = @employee.membership
    end
    def update
       @employee = User.find(params[:employee_id])
      @membership = @employee.create_membership(membership_params)
      if @membership.valid?
        @membership.save
        redirect_to employee_url(@employee), notice: "Membership saved successfully."
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