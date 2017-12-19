module Members
  class OfficesController < ApplicationController
    def edit
      @member = Member.find(params[:member_id])
    end
    def update
      @member = Member.find(params[:member_id])
      @member.update(office_params)
      if @member.save
        redirect_to member_url(@member), notice: "Office updated successfully"
      else
        render :edit
      end
    end
    private
    def office_params
      params.require(:member).permit(:office_id)
    end
  end
end

