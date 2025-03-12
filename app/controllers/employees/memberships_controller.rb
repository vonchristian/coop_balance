module Employees
  class MembershipsController < ApplicationController
    def new
      @employee = current_cooperative.users.find(params[:employee_id])
      @membership = @employee.build_membership
    end

    def create
      @employee = current_cooperative.users.find(params[:employee_id])
      @membership = @employee.create_membership(membership_params)
      if @membership.valid?
        @membership.save
        redirect_to employee_url(@employee), notice: "Membership saved successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @employee = current_cooperative.users.find(params[:employee_id])
      @membership = @employee.membership
    end

    def update
      @employee = current_cooperative.users.find(params[:employee_id])
      @membership = @employee.create_membership(membership_params)
      if @membership.valid?
        @membership.save
        redirect_to employee_url(@employee), notice: "Membership saved successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def membership_params
      params.require(:membership).permit(:membership_type)
    end
  end
end
