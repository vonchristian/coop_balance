module Members
  class BranchOfficesController < ApplicationController
    def edit
      @member = Member.find(params[:member_id])
    end
    def update
      @member = Member.find(params[:member_id])
      @member.update(branch_office_params)
      if @member.save
        redirect_to member_url(@member), notice: "Branch Office updated successfully"
      else
        render :edit
      end
    end
    private
    def branch_office_params
      params.require(:member).permit(:branch_office_id)
    end
  end
end

