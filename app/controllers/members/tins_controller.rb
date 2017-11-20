module Members
  class TinsController < ApplicationController
    def new
      @member = Member.friendly.find(params[:member_id])
      @tin = @member.build_tin
    end
    def create
      @member = Member.friendly.find(params[:member_id])
      @tin = @member.create_tin(tin_params)
      if @tin.save
        redirect_to @member, notice: "TIN number updated successfully"
      else
        render :new
      end
    end

    private
    def tin_params
      params.require(:tin).permit(:number)
    end
  end
end
