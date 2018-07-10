module Members
  class TinsController < ApplicationController
    def new
      @member = Member.find(params[:member_id])
      @tin = @member.tins.build
    end
    def create
      @member = Member.find(params[:member_id])
      @tin = @member.tins.create(tin_params)
      if @tin.save
        redirect_to member_info_index_url(@member), notice: "TIN number updated successfully"
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
